local assets=
{ 
    -- Asset("ANIM", "anim/starsword.zip"),
    -- Asset("ANIM", "anim/swap_starsword.zip"), 
     Asset("ANIM", "anim/ostuxkatana.zip"),
    Asset("ANIM", "anim/swap_ostuxkatana.zip"),

    Asset("ATLAS", "images/inventoryimages/starsword.xml"),
    Asset("IMAGE", "images/inventoryimages/starsword.tex"),
}

local prefabs = 
{
    "ydj_dst_td1madao_air_sword"
}

--local wilson_attack = 34
--WATHGRITHR_SPEAR_DAMAGE = wilson_attack * 1.25,
--TUNING.GROWINGSWORDLITE_DAMAGE = TUNING.WATHGRITHR_SPEAR_DAMAGE -- error on vanilla mode
TUNING.GROWINGSWORDLITE_DAMAGE = 50
TUNING.GROWINGSWORDLITE_RANGE = 1.05


local function setAttackDamage(inst)
    local dmg = (TUNING.GROWINGSWORDLITE_DAMAGE + 2 * inst.level)
    inst.components.weapon:SetDamage(dmg)
end


local function getString(inst)
    -- return "Level:"..inst.level..", Killing:"..inst.totalkilling..", Next:"..math.floor(inst.killing).."/"..math.ceil(inst.nextExp)
    return "Level:"..inst.level
end


local function leveling (inst, data)
    inst.totalkilling = inst.totalkilling + 1
    local kl = data.inst.components.health.maxhealth / 100
    inst.killing = inst.killing + kl

    if inst.killing >= inst.nextExp then
        inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
        inst.level = inst.level + 1
        inst.killing = inst.killing - inst.nextExp
--        inst.nextExp = inst.nextExp + 10/inst.level
        --inst.nextExp = inst.nextExp + 7.5/inst.level
        if inst.level <= 20 then 
            inst.nextExp = 5
        else 
            inst.nextExp = 20 + 5;
        end
    end
    inst.components.inspectable:SetDescription(getString(inst))
end

local function xLeveling (inst) 
    inst.level = inst.level + 1
    setAttackDamage(inst)
    
end


local function onEquip(inst, owner) 
    -- owner.AnimState:OverrideSymbol("swap_object", "swap_starsword", "symbol0")
    owner.AnimState:OverrideSymbol("swap_object", "swap_ostuxkatana", "ostuxkatana")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
    inst.myowner = owner
    owner.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE*2)
    -- if inst.level >= 5 and GetClock():IsNight() then
    --     local light = inst.entity:AddLight()
	-- 	light:SetFalloff(0.5)
	-- 	light:SetIntensity(0.5)
	-- 	light:SetRadius(4)
	-- 	light:SetColour(255/255,255/255,255/255)
	-- 	inst.entity:AddLight():Enable(true)
    -- end

    if inst.level >= 10 then
        inst:AddComponent("tool")
        inst.components.tool:SetAction(ACTIONS.CHOP, 7)
    end
    if inst.level >= 15 then
        inst:AddComponent("tool")
        inst.components.tool:SetAction(ACTIONS.CHOP, 20)
    end

end


local function onUnequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
    owner.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE)
    inst.myowner = nil
end


local function onSave(inst, data)
    data.xtotal = inst.xtotal
    data.totalkilling = inst.totalkilling
    data.level   = inst.level
    data.nextExp = inst.nextExp
    data.killing = inst.killing
end


local function onLoad(inst, data)
    if data then
        inst.totalkilling = data.totalkilling or 0
        inst.level   = data.level or 0
        inst.nextExp = data.nextExp or 0
        inst.killing = data.killing or 0
        inst.xtotal = data.xtotal or 0
    end

    setAttackDamage(inst)
    --inst.components.inspectable:SetDescription(getString(inst))
end

--判断是否可以施法
local function canpalymagic(staff, caster, target)
	return true
end

--召唤闪电
function firefn(inst, reader)

    local num_lightnings =  16
    reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
    reader:StartThread(function()
        for k = 0, num_lightnings do

            local rad = math.random(3, 15)
            local angle = k*((4*PI)/num_lightnings)
            local pos = Vector3(reader.Transform:GetWorldPosition()) + Vector3(rad*math.cos(angle), 0, rad*math.sin(angle))
            GetSeasonManager():DoLightningStrike(pos)
            Sleep(math.random( .3, .5))
        end
    end)
    return true
end

local function palymagic(staff, target)
    GetPlayer().components.talker:Say("以雷霆击碎黑暗！！")
    firefn(staff, GetPlayer())
end



--修复时调用的方法
local function ontakefuel(inst, giver, item)
    local gemArray = {"redgem", "bluegem", "purplegem", "greengem", "orangegem", "yellowgem"}
    local str = item.prefab
    --GetPlayer().components.talker:Say(str)
    for i= 1, 5 do
        if gemArray[i] == str then
            -- 目前只用宝石升级....一个宝石升一级..去除经验值递增升级
            -- inst.xtotal = inst.xtotal + 1
            -- local temp = inst.level / 2
            -- if inst.xtotal > temp then
            --     GetPlayer().components.talker:Say(getString(inst))
            --     xLeveling(inst)
            --     inst.xtotal = 0
            -- end
            GetPlayer().components.talker:Say(getString(inst))
            xLeveling(inst)
        end
    end
    if str == "ancient_gem" or str == "ancient_soul" then
        local finiteuses = inst.components.finiteuses
        finiteuses:SetUses(math.min(finiteuses.current+0.05*finiteuses.total,finiteuses.total))
    end
    --local finiteuses = inst.components.finiteuses
    --finiteuses:SetUses(math.min(finiteuses.current+0.05*finiteuses.total,finiteuses.total))
    
end

-- 击杀掉落
local function SpawnLootPrefab(inst, lootprefab)
    if lootprefab then
        local loot = SpawnPrefab(lootprefab)
        if loot then
            
            local pt = Point(inst.Transform:GetWorldPosition())           
            
            loot.Transform:SetPosition(pt.x,pt.y,pt.z)
            
            if loot.Physics then
            
                local angle = math.random()*2*PI
                loot.Physics:SetVel(2*math.cos(angle), 10, 2*math.sin(angle))

                if loot.Physics and inst.Physics then
                    pt = pt + Vector3(math.cos(angle), 0, math.sin(angle))*(loot.Physics:GetRadius() + inst.Physics:GetRadius())
                    loot.Transform:SetPosition(pt.x,pt.y,pt.z)
                end
                
                loot:DoTaskInTime(1, 
                    function() 
                        if not (loot.components.inventoryitem and loot.components.inventoryitem:IsHeld()) then
                            if not loot:IsOnValidGround() then
                                local fx = SpawnPrefab("splash_ocean")
                                local pos = loot:GetPosition()
                                fx.Transform:SetPosition(pos.x, pos.y, pos.z)
                                --PlayFX(loot:GetPosition(), "splash", "splash_ocean", "idle")
                                if loot:HasTag("irreplaceable") then
                                    loot.Transform:SetPosition(GetPlayer().Transform:GetWorldPosition())
                                else
                                    loot:Remove()
                                end
                            end
                        end
                    end)
            end
            
            return loot
        end
    end
end

-- data目标
local function onKill(inst, data)
    if inst.myowner == nil then return end
    if data.cause == inst.myowner.prefab
        and not data.inst:HasTag("veggie") 
        and not data.inst:HasTag("structure") then
        --leveling (inst, data)
        --xLeveling(inst)
        --setAttackDamage(inst)
        --onsupercrit(inst, data)
        local temp = math.random(0, 9)
        if math.random(0, 10) < 3 then
            SpawnLootPrefab(inst, "ancient_soul")
        end
        if math.random(0, 10) < 3 then
            SpawnLootPrefab(inst, "ancient_gem")
        end
    end    
end

local function SpawnIceFx(inst, target)
    if not inst then return end
    
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/swipe")
    
    local numFX = math.random(15,20)
    local pos = inst:GetPosition()
    local targetPos = target and target:GetPosition()
    local vec = targetPos - pos
    vec = vec:Normalize()
    local dist = pos:Dist(targetPos)
    local angle = inst:GetAngleToPoint(targetPos:Get())

    for i = 1, numFX do
        inst:DoTaskInTime(math.random() * 0.25, function(inst)
            local prefab = "icespike_fx_"..math.random(1,4)
            local fx = SpawnPrefab(prefab)
            if fx then
                local x = GetRandomWithVariance(0, 5)
                local z = GetRandomWithVariance(0, 5)
                local offset = (vec * math.random(dist * 0.25, dist)) + Vector3(x,0,z)
                fx.Transform:SetPosition((offset+pos):Get())
                
                local x,y,z = fx.Transform:GetWorldPosition()
                
                --每根冰柱的伤害半径
                local r = 2
                
                --每根冰柱的伤害
                local dmg = math.random(0, 1) * 30
                
                local ents = TheSim:FindEntities(x,y,z,r)
                for k, v in pairs(ents) do
                
                    ----发招忽略队友
                    if v and v.components.health and not v.components.health:IsDead() and v.components.combat and
                        v ~= inst and
                        not (v.components.follower and v.components.follower.leader == inst )-- and 
                    --    (TheNet:GetPVPEnabled() or not v:HasTag("player"))
                    then
                            v.components.combat:GetAttacked( inst, dmg )
                        
                        if v.components.freezable then
                            v.components.freezable:AddColdness(2)
                            v.components.freezable:SpawnShatterFX()
                        end
                        
                    end
                end
                
            end
        end)
    end
end



local function onattack(inst, attacker, target, skipsanity)
    SpawnPrefab("ydj_dst_td1madao_air_sword").Transform:SetPosition(inst.Transform:GetWorldPosition())

    local temp = math.random(0, 9)
    local temp1 = math.random(0, 100)
    if temp <= 3 then
        attacker.components.sanity:DoDelta(5)
        attacker.components.hunger:DoDelta(-2)
        SpawnIceFx(attacker, target)
        -- local pos = Vector3(attacker.Transform:GetWorldPosition())--天谴
        -- GetSeasonManager():DoLightningStrike(pos)
        return
    end
    if temp1 <= 1 then
        if attacker and attacker.components.talker then
            attacker.components.talker:Say("作者大大的意志，一剑西来，天外飞仙!")
        end
        target.components.health:DoDelta(-999999999)
        attacker.components.health:DoDelta(-20)
        attacker.components.sanity:DoDelta(-15)
    end
    
end

local function xAccept(inst, item, giver)
    local str = item.prefab
    local gemArray = {"redgem", "bluegem", "purplegem", "greengem", "orangegem", "yellowgem", "ancient_gem", "ancient_soul"}
    for i= 0, 8 do
        if gemArray[i] == str then
            return true
        end
    end
    return false
end


local function fn(colour)

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
--    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("ostuxkatana")
    anim:SetBuild("ostuxkatana")
    anim:PlayAnimation("idle")

    inst:AddTag("sharp")

--[[
    if not TheWorld.ismastersim then   
      return inst  
    end   
    
    inst.entity:SetPristine() 
]]

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.GROWINGSWORDLITE_DAMAGE)
	inst.components.weapon:SetRange(TUNING.GROWINGSWORDLITE_RANGE)

    -- inst:AddComponent("spellcaster")
    -- inst.components.spellcaster.canuseontargets = true
    -- inst.components.spellcaster.canusefrominventory = false
    -- inst.components.spellcaster:SetSpellTestFn(canpalymagic)--判断是否可以施法里面可以传入方法
    -- inst.components.spellcaster:SetSpellFn(palymagic)


    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(300)
    inst.components.finiteuses:SetUses(300)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst:AddComponent("trader")
    --inst.components.trader:SetAcceptTest(function(inst, item) return item and item.prefab == "ancient_soul" end)
    inst.components.trader:SetAcceptTest(xAccept)
    inst.components.trader.onaccept=ontakefuel
    --inst.components.trader.onaccept=function(inst,giver,item) 
	-- local finiteuses=inst.components.finiteuses
	-- finiteuses:SetUses(math.min(finiteuses.current+0.05*finiteuses.total,finiteuses.total))
    -- if giver.components.talker then 
    --     giver.components.talker:Say("他确实需要修复!!!")
    -- end
	-- end
    -- inst.components.trader.onrefuse=function(inst,giver,item)if giver.components.talker then giver.components.talker:Say("坏掉了!!!") end end
    
    
    -- inst:AddComponent("fueled")
    -- inst.components.fueled.fueltype = "ANCIENT_SOUL"
    -- inst.components.fueled.secondaryfueltype = "NIGHTMARE"
    -- inst.components.fueled:InitializeFuelLevel(4 * TUNING.LARGE_FUEL)

    -- inst.components.fueled.ontakefuelfn = ontakefuel
    -- inst.components.fueled.accepting = true
    


    inst.components.weapon:SetOnAttack(onattack)

	inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "starsword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/starsword.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onEquip)
    inst.components.equippable:SetOnUnequip(onUnequip)

    -- level
    inst.totalkilling = 0
    inst.level = 0
    inst.nextExp = 0
    inst.killing = 0
    inst.xtotal = 0
    inst.OnSave = onSave
    inst.OnLoad = onLoad
    inst.components.inspectable:SetDescription(getString(inst))

    


--    inst:ListenForEvent("entity_death", function(wrld, data) onKill(inst, data) end, TheWorld)
    inst:ListenForEvent("entity_death", function(wrld, data) onKill(inst, data) end, GetWorld())

--    MakeHauntableLaunch(inst)
    return inst
end

-- Add some strings for this item
-- STRINGS.NAMES.GROWINGSWORDLITE = "Growing Sword Lite"
-- STRINGS.CHARACTERS.GENERIC.DESCRIBE.GROWINGSWORDLITE = "Kill to be stronger, Switch on to boost attack damage."

return  Prefab("common/inventory/starsword", fn, assets, prefabs)
