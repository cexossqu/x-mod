local assets=
{ 
    Asset("ANIM", "anim/scythe.zip"),
    Asset("ANIM", "anim/swap_scythe.zip"), 

    Asset("ATLAS", "images/inventoryimages/scythe.xml"),
    Asset("IMAGE", "images/inventoryimages/scythe.tex"),
}

local prefabs = 
{
}

local function onfinished(inst)
    inst:Remove()
end

local function fn(colour)

    local function OnEquip(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_object", "swap_scythe", "scythe")
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal") 
    end

    local function OnUnequip(inst, owner) 
        owner.AnimState:Hide("ARM_carry") 
        owner.AnimState:Show("ARM_normal") 
    end

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("scythe")
    anim:SetBuild("scythe")
    anim:PlayAnimation("idle")
	
	inst:AddTag("sharp")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(33)
	-------
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)
	
	inst.components.finiteuses:SetOnFinished( onfinished )
	
	inst:AddComponent("inspectable")
	--------------------------------For add tool function--------------------------------
	inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP)
    inst.components.tool:SetAction(ACTIONS.MINE)
    inst.components.tool:SetAction(ACTIONS.DIG)
	inst.components.finiteuses:SetOnFinished( onfinished) 
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 0.5)
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 0.5)
    inst.components.finiteuses:SetConsumption(ACTIONS.DIG, 0.5)
	--------------------------------For add tool function--------------------------------
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "scythe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/scythe.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )

    return inst
end

----------------------------------------------------------------
return  Prefab("common/inventory/scythe", fn, assets)