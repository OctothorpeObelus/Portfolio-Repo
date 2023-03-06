--@name TF2 Rocket Launcher
--@author Octo
--@shared
--@include tf2 weapons/lib/swep_base.txt

--[[
    This recreates the behaviors of the stock rocket launcher from Team Fortress 2, and can even be given to other players.
    It also renders the viewmodel with proper lighting, done with a simple trick.
]]

require("tf2 weapons/lib/swep_base.txt")

local modelpath = "models/weapons/v_models/v_rocketlauncher_soldier.mdl"
setVModel(modelpath)
SWEP.FOV = 80
SWEP.AttackInterval = 0.8
SWEP.Clip1 = 4
SWEP.Clip1Max = 4
SWEP.AutoReload = true
SWEP.ReloadRate = 1

local function SWEPReload(num, rate)
    rate = rate or 1
    SWEP.Locked = true
    setVSequence("reload_start", 0, rate)
    timer.create("addAmmo", 0.8/rate, num, function()
        SWEP.Clip1 = SWEP.Clip1 + 1
    end)
    timer.create("r1", 0.5/rate, 1, function()
        setVSequence("reload_loop", 0, rate)
        timer.create("r2", (0.8*num)/rate, 1, function()
            setVSequence("reload_finish", -200, rate)
            timer.create("r3", 1, 1, function()
                setVSequence("idle", 0, rate)
                SWEP.Locked = false
            end)
        end)
    end)
end

--TODO: Fix bug where player can spam reload and attack1 and fire as fast as desired.
local function SWEPCancelReload()
    timer.stop("r1")
    timer.stop("r2")
    timer.stop("addAmmo")
    timer.stop("r3")
    SWEP.nextAttackTime = timer.systime()
    SWEP.Locked = false
end

local Fire = false
local IsEquipped = false

if SERVER then
    local user = owner()
    local hudEnt = prop.createComponent(chip():localToWorld(Vector(0,0,54)),chip():localToWorldAngles(Angle(0,0,0)),"starfall_hud","models/props_lab/monitor01a.mdl",false)
    hudEnt:linkComponent(chip())
    hudEnt:setParent(chip())

    local function changeUser(ply)
        if not isValid(ply) then return end
        user = ply
        setSWEPUser(user, modelpath)
        net.start("setOwnerCL")
        net.writeEntity(user)
        net.send()
        print(Color(255),"[",Color(180,255,180),"Rocket Launcher (Id: "..tostring(chip():entIndex())..")",Color(255),"] Given rocket launcher to ",Color(150,255,150),user:getName())
    end

    --Allow for the chip owner to hand out weapons to other players.
    hook.add("PlayerSay", "octoPlayerSayUserHandoff", function(ply, text)
        text = string.explode(" ", text)
        if ply == owner() and text[1] == "!give" and text[2] == tostring(chip():entIndex()) then
            local ply = find.playersByName(text[3], false, false)[1]
            changeUser(ply)
        end
    end)

    --Give a player the rocket launcher if they connect to the HUD
    hook.add("hudconnected", "octoHudConnectedRocketLauncher", function(ent, ply)
        changeUser(ply)
        --printHud(ply, Color(255),"[",Color(180,255,180),"Rocket Launcher",Color(255),"] You got a Rocket Launcher!")
        --printHud(ply, Color(255), "Tool perms required to do damage or rocket jump!")
        printHud(ply, Color(255), "Equip your hands to use the Rocket Launcher.")
    end)

    local rockets = {}
    
    local critChance = 0.02
    local d20 = 0 --Damage done in the last 20 seconds.
    net.receive("fireRocket", function(len, ply)
        if not holograms.canSpawn() then 
            print(Color(255,255,255),"[",Color(180,255,180),"Rocket Launcher",Color(255,255,255),"] Maximum holograms reached!")
            return
        end
        local thenew = {}
        --Default is Vector(-23.5, -12, -3) but this needs to be shortened for gmod characters
        thenew.firePos = localToWorld(Vector(0, -12, -3), Angle(0,0,0), ply:getEyePos(), ply:getEyeAngles())
        local Trace = trace.trace(thenew.firePos, localToWorld(Vector(-23.5, -12, -3), Angle(0,0,0), ply:getEyePos(), ply:getEyeAngles()), user)
        thenew.firePos = Trace.HitPos
        thenew.fireDir = trace.trace(Trace.HitPos, ply:getEyeTrace().HitPos).Normal
        thenew.speed = 1100 --Units per second of speed of the rocket.
        thenew.isCritical = math.random() <= (critChance + math.min(0.1, 0.1*(d20/800)))
        thenew.holo = holograms.create(thenew.firePos, ply:getEyeAngles(), "models/weapons/w_models/w_rocket.mdl")
        thenew.holo:setColor(Color(255, 255, 255, 0))
        thenew.deathTime = 0
        thenew.owner = user
        
        timer.simple(timer.frametime()*2, function()
            net.start("rocketTrail")
            net.writeEntity(thenew.holo)
            net.writeBool(thenew.isCritical)
            net.send()
            thenew.holo:setColor(Color(255, 255, 255, 255))
        end)
        
        net.start("firingSound")
        net.writeBool(thenew.isCritical)
        net.send()
        
        --Add rocket to the server rockets table to be simulated.
        rockets[#rockets+1] = thenew
    end)
    
    local function explodeRocket(hitpos, IsCritical, directHitEnt, owner)
        timer.simple(timer.frametime()*6, function()
            directHitEnt = directHitEnt or nil
            local damage = math.round(math.remap(1280 - math.clamp(user:getPos():getDistance(hitpos), 256, 1024), 256, 1024, 48, 112))
            
            net.start("explosionSound")
            net.writeVector(hitpos)
            net.send()
            
            --Damage a player with direct hit logic if they were hit directly by the rocket
            if isValid(directHitEnt) and hasPermission("entities.applyDamage", directHitEnt) then
                local dmg = damage
                
                if directHitEnt == user then dmg = math.round(dmg * 0.4) end
                if IsCritical then
                    dmg = 270
                end
                directHitEnt:applyDamage(dmg, user, user)
                
                if isValid(directHitEnt:getPhysicsObject()) then
                    --Damage scaling.
                    local scale
                    if directHitEnt:isOnGround() then scale = 5 else scale = 10 end
                    local forceDir = (directHitEnt:getMassCenterW()-hitpos):getNormalized()
                    local force = dmg * ((48*48*82)/directHitEnt:getPhysicsObject():getVolume()) * scale
                    
                    if directHitEnt:getClass() == "player" and hasPermission("entities.setVelocity", directHitEnt) then
                        directHitEnt:setVelocity(directHitEnt:getVelocity() + (forceDir * force * 0.0916))
                    elseif hasPermission("entities.applyForce", directHitEnt) then
                        directHitEnt:getPhysicsObject():setVelocity(directHitEnt:getVelocity() + (forceDir * force * 0.0916))
                    end
                end
            end
            
            --Handle splash damage of the rocket to everyone except the player directly hit (if any)
            find.inSphere(hitpos, 146, function(ent)
                if ent:getClass() != "player" and ent:getClass() != "prop_physics" and string.find(ent:getClass(), "npc_") == nil then return false end
                if ent == directHitEnt then return end
                
                local forceDir = (ent:getMassCenterW()-hitpos):getNormalized()
                
                --Owner self-damage reduction.
                if ent == owner and hasPermission("entities.applyDamage", ent) then
                    ent:applyDamage(damage * 0.4, owner, owner)
                end
                
                if IsCritical and ent != owner then damage = 270 end
                local dmg = damage - ((damage*0.01) * (hitpos:getDistance(ent:getPos())/2.88))
                
                --Damage scaling.
                local scale
                if ent:isOnGround() then scale = 5 else scale = 10 end
                --if ent == owner then dmg = dmg * 0.4 end
                
                if IsCritical and ent:getHealth() > 0 then
                    net.start("criticalShit")
                    net.send(user)
                end
                
                if not isValid(ent:getPhysicsObject()) then return end 
                if ent:getPhysicsObject():getVolume() == nil then return end
                
                local force = dmg * ((48*48*82)/ent:getPhysicsObject():getVolume()) * scale
                
                if ent:getClass() == "player" and hasPermission("entities.setVelocity", ent) then
                    ent:setVelocity(ent:getVelocity() + (forceDir * force * 0.0916))
                elseif hasPermission("entities.applyForce", ent) then
                    ent:getPhysicsObject():setVelocity(ent:getVelocity() + (forceDir * force * 0.0916))
                end
                
                if hasPermission("entities.applyDamage", ent) then
                    if ent != owner and ent:getHealth() > 0 then
                        ent:applyDamage(dmg, user, user)
                    end
                end
                
            end)
        end)
    end
    
    --Destroy the given rocket entity
    local function killRocket(rocket)
        rocket.holo:setColor(Color(255, 255, 255, 0))
        timer.simple(1, function()
            net.start("rocketDying")
            net.writeEntity(rocket.holo)
            net.send()
        end)
    end
    
    --Simulate every rocket that is currently alive.
    hook.add("tick", "octoRocketsTickRocketLauncher", function()
        local delta = timer.frametime()
        local rocketsDied = false
        for _,rocket in pairs(rockets) do
            --See if we can remove this dead rocket.
            if rocket.deathTime != 0 then
                if timer.systime() > rocket.deathTime + 3 and isValid(rocket.holo) then rocket.holo:remove() table.remove(rockets, _) end
                continue
            end
            
            local pos = rocket.holo:getPos()
            local nextPos = pos + rocket.fireDir * Vector(rocket.speed) * delta
            local Trace = trace.trace(pos, nextPos, user)
            
            if Trace.HitSky then
                killRocket(rocket)
                rocket.deathTime = timer.systime()
                continue
            elseif Trace.HitNonWorld then
                killRocket(rocket)
                explodeRocket(Trace.HitPos, rocket.isCritical, Trace.Entity, rocket.owner)
                rocket.deathTime = timer.systime()
                continue
            elseif Trace.HitWorld then
                killRocket(rocket)
                explodeRocket(Trace.HitPos, rocket.isCritical, nil, rocket.owner)
                rocket.deathTime = timer.systime()
                continue
            end
            
            rocket.holo:setPos(nextPos)
        end
    end)
    
    --Keep track of how much damage we did in the last 20 seconds (timer hell).
    hook.add("EntityTakeDamage", "octoEntityTakeDamageRocketLauncher", function(target, attacker, inflictor, amount, type, pos, force)
        if target == attacker or attacker != user then return end
        if target:getClass() != "player" or string.find(target:getClass(), "npc") == nil then return end
        
        d20 = d20 + amount
        
        timer.create(tostring(timer.systime()), 20, 1, function() d20 = d20 - amount end)
    end)
else
    local user = owner()
    local activeParticles = 0
    
    setName("\nTF2 Rocket Launcher\nUser: "..user:getName().."\n# of Launchers: 1\n")
    
    --Create the worldmodel
    local wpos = user:localToWorld(Vector(0, -12, -7.5))--user:localToWorld(Vector(-23.5,-14,57.5))
    local wang = user:localToWorldAngles(Angle(0,0,0))
    local wmodel = holograms.create(wpos, wang, "models/weapons/w_models/w_rocketlauncher.mdl")
    hook.add("ClientInitialized", "wmodelInit", function(ply)
        if ply ~= owner() then return end
        wmodel:setPos(user:localToWorld(Vector(0, -12, -7.5)))
        wmodel:setAngles(user:localToWorldAngles(Angle(0,0,0)))
        wmodel:setParent(user, nil, 7) --Parent to forward bone
    end)
    
    --Set the owner of the rocket launcher
    net.receive("setOwnerCL",function()
        user = net.readEntity()
        setSWEPUser(user, modelpath)
        setName("\nTF2 Rocket Launcher\nUser: "..user:getName().."\n# of Launchers: 1\n")
        wmodel:setParent(nil)
        wpos = user:localToWorld(Vector(0, -12, -7.5))--user:localToWorld(Vector(-23.5,-14,57.5))
        wang = user:localToWorldAngles(Angle(0,0,0))
        wmodel:setPos(wpos)
        wmodel:setAngles(wang)
        wmodel:setParent(user, nil, 7) --Parent to forward bone
        setVSequence("draw")
    end)

    --Server-wide max particles
    local maxParticles = 16
    if player() == owner() then
        maxParticles = convar.getInt("sf_particleeffects_max_cl")
    end
    local numChips = 1
    local knownChips = {}

    --Let other launchers know we exist to share particle limits.
    timer.simple(timer.frametime()*10, function()
        hook.runRemote(nil, "marco")
    end)

    --This is literally just to share the particle limit since particle.particleEmittersLeft() is broken.
    --Handles communications to figure out just how many of these chips are out there to share the limit with.
    hook.add("remote", "octoRemoteRocketLauncher", function(sender, owner, tag)
        if sender == chip() then return end
        --Someone has responded, letting us know they exist. Increment the count.
        if tag == "polo" and !table.hasValue(knownChips, sender) then
            knownChips[#knownChips+1] = sender
            numChips = numChips + 1
        end
        --Someone is calling out to find out how many of us there are, respond to them.
        if tag == "marco" and !table.hasValue(knownChips, sender) then
            knownChips[#knownChips+1] = sender
            hook.runRemote(nil, "polo")
            numChips = numChips + 1
        end
        --One of us just died so decrement the count.
        if tag == "removed" then
            table.removeByValue(knownChips, sender)
            numChips = numChips - 1
        end
        
        --Divide up the particle limit evenly between chips.
        if hasPermission("convar", player()) then
            maxParticles = math.floor(convar.getInt("sf_particleeffects_max_cl")/numChips)
        end
        setName("\nTF2 Rocket Launcher\nUser: "..user:getName().."\n# of Launchers: "..tostring(numChips).."\n")
    end)
    
    hook.add("Removed", "octoRemovedRocketLauncher", function()
        hook.runRemote(nil, "removed")
    end)
    
    local function canCreateParticle()
        return activeParticles < maxParticles
    end
    
    local function makeParticle(ent, part, pattach, options)
        if not canCreateParticle() then return end
        local particl = particleEffect.attach(ent, part, pattach, options)
        activeParticles = activeParticles + 1
        return particl
    end
    
    local function killParticle(part)
        part:destroy()
        activeParticles = activeParticles - 1
    end
    
    if player() == user then setVSequence("draw", -200) end
    
    hook.add("KeyPress", "octoInputPressedRocketLauncher", function(ply, button)
        if ply != user or !IsEquipped then return end
        
        if button == 1 then --ATTACK1
            Fire = true
        end
        
        if button == 8192 and !SWEP.Locked then --RELOAD
            if SWEP.Clip1 == SWEP.Clip1Max then return end
            SWEPReload(SWEP.Clip1Max - SWEP.Clip1, SWEP.ReloadRate)
        end
    end)
    
    hook.add("KeyRelease", "octoInputReleasedRocketLauncher", function(ply, button)
        if ply != user or !IsEquipped then return end
        
        if button == 1 then --ATTACK1
            Fire = false
        end
    end)
    
    local lastEquipState
    hook.add("think", "octoTickRocketLauncher", function()
        --Only equip the weapon if the player has their hands out.
        IsEquipped = isValid(user:getActiveWeapon()) and user:getActiveWeapon():getPrintName() == "hands"
        
        --And the worldmodel
        local p, a = user:getBonePosition(9)
        --wmodel:setPos(localToWorld(Vector(0,10,0), Angle(0), p, a)) --RUpperArm
        --wmodel:setAngles((user:getEyeAngles() + Angle(0, -5, 0)) * Angle(0.75,1,1))
        
        if IsEquipped and player() != user and hasPermission("entities.setRenderProperty", user) then wmodel:setColor(Color(255,255,255,255)) else wmodel:setColor(Color(255,255,255,0)) end
        
        if player() != user then return end
        
        if Fire and IsEquipped then
            if SWEPCanFire() or (SWEP.Clip1 > 0 and SWEP.Locked) then
                SWEPCancelReload()
                timer.simple(timer.frametime()*2, function()
                    setVSequence("fire", -200)
                    SWEP.Clip1 = SWEP.Clip1 - 1
                end)
                SWEP.nextAttackTime = timer.systime() + SWEP.AttackInterval
                net.start("fireRocket")
                net.send()
            elseif SWEP.Clip1 <= 0 and timer.systime() > SWEP.nextAttackTime and !SWEP.Locked then
                SWEPReload(SWEP.Clip1Max, SWEP.ReloadRate)
            end
        end
        
        if !lastEquipState and IsEquipped then
            setVSequence("draw", -200)
        end
        
        --Cancel reload if the weapon is away.
        if lastEquipState and !IsEquipped then
            SWEPCancelReload()
            setVSequence("draw")
        end
        
        lastEquipState = IsEquipped
    end)
    
    hook.add("drawHUD", "octoDrawHUDRocketLauncher", function()
        
        
        if not IsEquipped then return end
        
        renderVModel()
        
        render.drawSimpleText(24, 512, SWEP.Clip1 .. "/" .. SWEP.Clip1Max)
        
        --render.drawSimpleText(24, 532, string.format("%.2f", tostring(math.round(ramUsed()/1000, 2))) .. "/" .. math.round(ramMax()/1000, 2) .. "MB (" .. math.round((ramUsed()/ramMax())*100) .. "%)")
        --render.drawSimpleText(24, 552, "Active particles: " .. activeParticles .. " (" .. math.round(100*(activeParticles/16)) .. "%)")
    end)
    
    net.receive("firingSound", function()
        local isCritical = net.readBool()
        
        if hasPermission("entities.emitSound", user) then
            if isCritical then
                user:emitSound("weapons/rocket_shoot_crit.wav", 75, 100, 1, 1)
            else
                user:emitSound("weapons/rocket_shoot.wav", 75, 100, 1, 1)
            end
        end
    end)
    
    --Play the correct explosion sound based on the environment the rocket exploded in.
    net.receive("explosionSound", function()
        local pos = net.readVector()
        local crit = net.readBool()
        local rand = math.random(1,2)
        local path
        
        if rand == 1 then path = "weapons/explode1.wav"
        else path = "weapons/explode2.wav" end
        
        --Since sounds are attached to entities, this is needed so when the rocket is removed the sound isn't cut off.
        local snd = holograms.create(pos, Angle(0,0,0), "models/Gibs/HGIBS.mdl", Vector(0))
        snd:setColor(Color(0,0,0,0))
        snd:emitSound(path, 75, 100, 0.8)
        
        if canCreateParticle() then 
            local explosion
            
            if snd:getWaterLevel() != 3 then
                explosion = makeParticle(snd, "ExplosionCore_MidAir", 1, {attachtype = PATTACH.ABSORIGIN})
            else
                explosion = makeParticle(snd, "ExplosionCore_MidAir_underwater", 1, {attachtype = PATTACH.ABSORIGIN})
            end
            
            timer.simple(1.75, function()
                killParticle(explosion)
            end)
        end
        
        timer.simple(sounds.duration(path), function()
            snd:remove()
        end)
    end)
    
    --Play a critical hit sound
    net.receive("criticalShit", function()
        local rand = math.random(1,5)
        if rand == 1 then rand = "" end
        user:emitSound("player/crit_hit"..rand..".wav")
    end)
    
    --Particles table for storing all active particles
    local particles = {}
    
    net.receive("rocketTrail", function()
        local holo = net.readEntity()
        local crocket = net.readBool()
        local parts = {}
        parts.holo = holo
        
        if not isValid(holo) then return end
        
        if crocket then
            parts.crit = makeParticle(holo, "critical_rocket_red", 1, {attachtype = PATTACH.POINT_FOLLOW})
            parts.sparks = makeParticle(holo, "critical_rocket_redsparks", 1, {attachtype = PATTACH.POINT_FOLLOW})
        end
        
        if holo:getWaterLevel() != 3 then
            parts.trail = makeParticle(holo, "rockettrail", 1, {attachtype = PATTACH.POINT_FOLLOW})
        else
            parts.trail = makeParticle(holo, "rockettrail_waterbubbles", 1, {attachtype = PATTACH.POINT_FOLLOW})
        end
        
        particles[#particles+1] = parts
    end)
    
    --Remove the particles from the rocket before death so we don't have any zombies.
    net.receive("rocketDying", function()
        local holo = net.readEntity()
        for _,v in pairs(particles) do
            if v.holo == holo then
                if v.crit != nil then killParticle(v.crit) end
                if v.sparks != nil then killParticle(v.sparks) end
                if v.trail != nil then killParticle(v.trail) end
                table.remove(particles, _)
            end
        end
    end)
    
    if player() == user then
        enableHud(nil, true)
    end
end

