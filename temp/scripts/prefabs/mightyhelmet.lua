local assets = 
{
	Asset("ANIM", "anim/hat_x.zip"),
	    Asset("IMAGE", "images/inventoryimages/mightyhelmet.tex"),
    Asset("ATLAS", "images/inventoryimages/mightyhelmet.xml"),
}

-- local function FackHelmet(inst)
	-- -inst:Remove()
-- end

local function onequip(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_hat", "hat_x", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAT_HAIR")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")

		if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAIR")
        end
        -- if inst.level >= 5 then
            -- local light = inst.entity:AddLight()
            -- light:SetFalloff(0.5)
            -- light:SetIntensity(0.5)
            -- light:SetRadius(4)
            -- light:SetColour(255/255,255/255,255/255)
            -- inst.entity:AddLight():Enable(true)

        -- end
end

local function onunequip(inst, owner) 
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
	if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
    end
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
local function xLeveling (inst) 
    inst.level = inst.level + 1
    --setAttackDamage(inst)
end

local function ontakefuel(inst)
    if inst.components.armor.condition and inst.components.armor.condition < 0 then
        inst.components.armor:SetCondition(0)
    end
    inst.components.armor:SetCondition( math.min( inst.components.armor.condition + (inst.components.armor.maxcondition/20), inst.components.armor.maxcondition) )
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

local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	
   
if SaveGameIndex:IsModeShipwrecked() then
	MakeInventoryFloatable(inst, "idle_water", "anim")
end
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hat_x")
    inst.AnimState:SetBuild("hat_x")
    inst.AnimState:PlayAnimation("anim")
  

    inst:AddTag("hat")

    inst:AddTag("waterproofer")
   
    inst:AddComponent("inspectable")

    -------防具  450生命值 80%抗性（属性等同猪皮帽）
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(1000, 0.8)
    -------20%防雨
    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(1)
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mightyhelmet.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	-----------装备增加移速

    --增加燃料修复组件
    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "ANCIENT_SOUL"
    inst.components.fueled.secondaryfueltype = "NIGHTMARE"
    --inst.components.fueled:InitializeFuelLevel(4 * TUNING.LARGE_FUEL)

    inst.components.fueled.ontakefuelfn = ontakefuel
    inst.components.fueled.accepting = true

    inst:AddComponent("inspectable")

    inst.level = 0
    inst.xtotal = 0
    inst.OnSave = onSave
    inst.OnLoad = onLoad

    return inst
end

return Prefab("common/inventory/mightyhelmet", fn, assets)
