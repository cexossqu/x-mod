local assets = {
    Asset("ANIM", "anim/ydj_dst_td1madao_air_sword.zip"),
}



local prefabs = 
{
}

local function fn()

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
    inst.persists = false
    inst.entity:AddSoundEmitter()
    inst.AnimState:SetBuild("ydj_dst_td1madao_air_sword")
    inst.AnimState:SetBank("ydj_dst_td1madao_air_sword")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetMultColour(1, 1, 1, 0.7)
    inst.Transform:SetScale(1.75, 1.75, 1.75)

    return inst
end

return  Prefab("ydj_dst_td1madao_air_sword", fn, assets, prefabs)