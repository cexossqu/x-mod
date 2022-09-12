local assets=
{
	Asset("ANIM", "anim/armor_strongdamager.zip"),
	Asset("IMAGE", "images/inventoryimages/mightyarmor.tex"),
    Asset("ATLAS", "images/inventoryimages/mightyarmor.xml"),
}
local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour") 
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_strongdamager", "swap_body")
    inst:ListenForEvent("blocked", OnBlocked, owner)
    if inst.level >= 5 then
        -- local light = inst.entity:AddLight()
        -- light:SetFalloff(0.5)
        -- light:SetIntensity(0.5)
        -- light:SetRadius(4)
        -- light:SetColour(255/255,255/255,255/255)
        -- inst.entity:AddLight():Enable(true)
        
    end
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
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





local function fn(Sim)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "idle_water", "anim")
    
    inst.AnimState:SetBank("armor_strongdamager")
    inst.AnimState:SetBuild("armor_strongdamager")
    inst.AnimState:PlayAnimation("anim")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/metalarmour"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/mightyarmor.xml"
	
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(2500, TUNING.ARMORRUINS_ABSORPTION)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "ANCIENT_SOUL"
    --inst.components.fueled:InitializeFuelLevel(4 * TUNING.LARGE_FUEL)

    inst.components.fueled.ontakefuelfn = ontakefuel
    inst.components.fueled.accepting = true
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable.dapperness = -TUNING.DAPPERNESS_TINY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 0.30

    inst:AddComponent("inspectable")

    inst.level = 0
    inst.xtotal = 0
    inst.OnSave = onSave
    inst.OnLoad = onLoad
	
    return inst
end

return Prefab( "common/inventory/mightyarmor", fn, assets) 
