local IsDLC2 = IsDLCEnabled(CAPY_DLC)
local assets=
{
	Asset("ANIM", "anim/ancient_soul.zip"),
	
	Asset("ATLAS", "images/inventoryimages/ancient_soul.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_soul.tex"),
}

local function fn()
    
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	--inst.entity:AddSoundEmitter()
	--inst.entity:AddPhysics()
--	inst.entity:AddNetwork()
	inst.entity:AddLight()
	
    MakeInventoryPhysics(inst)
	RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("ancient_soul")
    inst.AnimState:SetBuild("ancient_soul")
    inst.AnimState:PlayAnimation("idle")

	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	
	inst.Light:Enable(true)
	inst.Light:SetRadius(2)
    inst.Light:SetFalloff(.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(238/255, 255/255, 143/255)
	
--	inst.entity:SetPristine()
 --   if not TheWorld.ismastersim then
 --       return inst
--    end
	
    --inst:AddComponent("edible")
    --inst.components.edible.foodtype = "ELEMENTAL"
    --inst.components.edible.hungervalue = 2
    --inst:AddComponent("tradable")
    
    inst:AddComponent("inspectable")
    inst:AddComponent("tradable")
    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = "ANCIENT_SOUL"
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    --添加可可食用
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = -5
    inst.components.edible.perishtime = TUNING.PERISH_MED
    inst.components.edible.caffeinedelta = TUNING.CAFFEINE_FOOD_BONUS_SPEED
    inst.components.edible.caffeinedelta = 3
    inst.components.edible.caffeineduration = TUNING.FOOD_SPEED_LONG
    inst.components.edible.foodtype = "VEGGIE"
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 99
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ancient_soul.xml"

if IsDLC2 then
	MakeInventoryFloatable(inst, "idle", "idle") -- 水  陆
end  
    return inst
end

return Prefab( "common/inventory/ancient_soul", fn, assets) 
