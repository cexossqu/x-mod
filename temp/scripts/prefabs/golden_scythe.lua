local assets=
{ 
    Asset("ANIM", "anim/golden_scythe.zip"),
    Asset("ANIM", "anim/swap_golden_scythe.zip"), 

    Asset("ATLAS", "images/inventoryimages/golden_scythe.xml"),
    Asset("IMAGE", "images/inventoryimages/golden_scythe.tex"),
}

local prefabs = 
{
}

local function onfinished(inst)
    inst:Remove()
end

local function xLeveling (inst) 
    inst.level = inst.level + 1
    --setAttackDamage(inst)
end

local function ontakefuel(inst)
    local finiteuses=inst.components.finiteuses
    finiteuses:SetUses(math.min(finiteuses.current+0.05*finiteuses.total,finiteuses.total))
    GetPlayer().components.talker:Say("地主家也没有余粮啊！！")
    -- inst.components.armor:SetCondition( math.min( inst.components.armor.condition + (inst.components.armor.maxcondition/20), inst.components.armor.maxcondition) )
    --GetPlayer().components.sanity:DoDelta(-TUNING.SANITY_TINY)
    --GetPlayer().SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/vortex_armour/add_fuel") 添加的声音  
    inst.xtotal = inst.xtotal + 1
    local temp = inst.level / 2
    if inst.xtotal > temp then
        --GetPlayer().components.talker:Say(getString(inst))
        xLeveling(inst)
        inst.xtotal = 0
    end
end

--判断是否可以施法
local function canpalymagic(staff, caster, target)
	return true
end

local function onSave(inst, data)
    data.xtotal = inst.xtotal
    data.level   = inst.level
end

local function onLoad(inst, data)
    if data then
        inst.level   = data.level or 0
        inst.xtotal = data.xtotal or 0
    end

    --setAttackDamage(inst)
    --inst.components.inspectable:SetDescription(getString(inst))
end

-- 催熟
function growfn(inst, reader)
    reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
    local range = 30
    local pos = Vector3(reader.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, range)
    for k,v in pairs(ents) do
        if v.components.pickable then
            v.components.pickable:FinishGrowing()
        end

        if v.components.crop then
            v.components.crop:DoGrow(TUNING.TOTAL_DAY_TIME*3)
        end
        
        if v:HasTag("tree") and v.components.growable and not v:HasTag("stump") then
            v.components.growable:DoGrowth()
        end
    end
    return true
end

local function palymagic(staff, target)
    GetPlayer().components.talker:Say("这要耗费我多少精力！！")
    growfn(staff, GetPlayer())
end


local function fn(colour)

    local function OnEquip(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_object", "swap_golden_scythe", "golden_scythe")
		owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")   
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal")
        owner.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE*2) 
        -- if inst.level >= 5 then
        --     local light = inst.entity:AddLight()
        --     light:SetFalloff(0.5)
        --     light:SetIntensity(0.5)
        --     light:SetRadius(4)
        --     light:SetColour(255/255,255/255,255/255)
        --     inst.entity:AddLight():Enable(true)
        -- end
    end

    local function OnUnequip(inst, owner) 
        owner.AnimState:Hide("ARM_carry") 
        owner.AnimState:Show("ARM_normal")
        owner.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE) 
    end

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("golden_scythe")
    anim:SetBuild("golden_scythe")
    anim:PlayAnimation("idle")
	
	inst:AddTag("sharp")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(50)
    -------
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200)
    inst.components.finiteuses:SetUses(200)
	
	inst.components.finiteuses:SetOnFinished( onfinished )
	
	inst:AddComponent("inspectable")
	--------------------------------For add tool function--------------------------------
	inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 2)
    inst.components.tool:SetAction(ACTIONS.MINE, 2)
    inst.components.tool:SetAction(ACTIONS.DIG)	
	inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 0.5)
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 0.5)
    inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 0.5)
	--end

    -- inst:AddComponent("spellcaster")
    -- inst.components.spellcaster.canuseontargets = true
    -- inst.components.spellcaster.canusefrominventory = false
    -- inst.components.spellcaster:SetSpellTestFn(canpalymagic)--判断是否可以施法里面可以传入方法
    -- inst.components.spellcaster:SetSpellFn(palymagic)
	
    inst.components.finiteuses:SetOnFinished(onfinished) 
    --inst.components.finiteuses:SetConsumption(ACTIONS.MOWDOWN, TUNING.GOLD_SCYTHE_DURABILITY) --Adjust the speed of consumption durability as the tool. Now is 300 uses.
	--------------------------------For add tool function--------------------------------
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "golden_scythe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/golden_scythe.xml"

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "ANCIENT_SOUL"
    inst.components.fueled.secondaryfueltype = "NIGHTMARE"
    inst.components.fueled:InitializeFuelLevel(4 * TUNING.LARGE_FUEL)

    inst.components.fueled.ontakefuelfn = ontakefuel
    inst.components.fueled.accepting = true
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
    inst.components.equippable.walkspeedmult = 0.35

    inst:AddComponent("inspectable")

    inst.level = 0
    inst.xtotal = 0
    inst.OnSave = onSave
    inst.OnLoad = onLoad
    --inst.components.inspectable:SetDescription(getString(inst))
	

    return inst
end

----------------------------------------------------------------
return  Prefab("common/inventory/golden_scythe", fn, assets)