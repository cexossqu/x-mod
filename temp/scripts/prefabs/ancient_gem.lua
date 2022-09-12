local IsDLC2 = IsDLCEnabled(CAPY_DLC)
local assets=
{
	Asset("ANIM", "anim/ancient_gem.zip"),
	
	Asset("ATLAS", "images/inventoryimages/ancient_gem.xml"),
    Asset("IMAGE", "images/inventoryimages/ancient_gem.tex"),
}

local function item_oneaten(inst, eater)

    if eater.wormlight then
        eater.wormlight.components.spell.lifetime = 0
        eater.wormlight.components.spell.duration = 300
        eater.wormlight.components.spell:ResumeSpell()
    else
        local light = SpawnPrefab("wormlight_light")
        light.components.spell:SetTarget(eater)
        if not light.components.spell.target then
            light:Remove()
        end
        light.components.spell.duration = 300
        light.components.spell:StartSpell()
    end
end

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

	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )    
	
    inst.AnimState:SetBank("ancient_gem")
    inst.AnimState:SetBuild("ancient_gem")
    inst.AnimState:PlayAnimation("idle")

	inst.Light:Enable(true)
	inst.Light:SetRadius(2)
    inst.Light:SetFalloff(.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(238/255, 155/255, 143/255)
	
--	inst.entity:SetPristine()
--	if not TheWorld.ismastersim then
--        return inst
--    end
	
    --inst:AddComponent("edible")
    --inst.components.edible.foodtype = "ELEMENTAL"
    --inst.components.edible.hungervalue = 2
    
    inst:AddComponent("tradable")
    inst:AddComponent("fuel")
    --inst.components.fuel.fuelvalue = TUNING.MED_LARGE_FUEL
    inst.components.fuel.fuelvalue = 999
    inst.components.fuel.fueltype = "ANCIENT_SOUL"
    
    inst:AddComponent("inspectable")

    --添加可可食用
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.sanityvalue = -5
    inst.components.edible.hungervalue = 0
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible:SetOnEatenFn(item_oneaten)
    
	-- ����Զ�ż�̳sanity
	--local function OnDeploy (inst, pt)
    --SpawnPrefab("ancient_altar").Transform:SetPosition(pt.x, pt.y, pt.z)
    --inst.components.stackable:Get():Remove()
	--end
    --inst:AddComponent("deployable")
    --inst.components.deployable.ondeploy = OnDeploy
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 99
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ancient_gem.xml"

if IsDLC2 then
	MakeInventoryFloatable(inst, "idle", "idle") -- ˮ  ½
end
    --inst:AddComponent("bait")
    --inst:AddTag("molebait")
    
    return inst
end

return Prefab( "common/inventory/ancient_gem", fn, assets) 
