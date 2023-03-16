--@name Alien Isolation Motion Tracker
--@author Octo
--@shared

--Get the complement of two tables.
local function complement(tbl1, tbl2)
    if tbl1 == tbl2 then return {} end
    
    local out = {}
    
    for _,v in pairs(tbl1) do
        if not table.hasValue(tbl2, v) then
            out[#out+1] = v
        end
    end
    
    for _,v in pairs(tbl2) do
        if not table.hasValue(tbl1, v) then
            out[#out+1] = v
        end
    end
    
    return out
end

if SERVER then
    local lamp = prop.createSent(chip():getPos() + Vector(0,0,75), Angle(90,0,0), "gmod_lamp", true, {
        on = true,
        brightness = 0,
        fov = 360,
        Model = "models/maxofs2d/lamp_flashlight.mdl",
    })
    lamp:setColor(Color(0,0,0,0))
    lamp:setCollisionGroup(10) -- COLLISION_GROUP_IN_VEHICLE
    hook.add("tick", "octoAIMTSVTick", function()
        lamp:setPos(owner():getPos() + Vector(0,0,512))
    end)
else
    local lastPulse = timer.curtime()
    local matsLoaded = 0
    local numMats = 5
    
    --Rendertarget for the screen on the model itself.
    render.createRenderTarget("screenRT")
    -- Create a new material, we will set the hologram's material to this later
    local screenMat = material.create("UnlitGeneric") 
    -- Set the material's texture to the render target that we've just created
    screenMat:setTextureRenderTarget("$basetexture", "screenRT") 
    -- Clear the material's flags
    screenMat:setInt("$flags", 0)
    screenMat:setUndefined("$translucent")
    screenMat:setInt("$selfillum", 1)
    
    --Hologram setup stuff.
    local MetalMat = "models/props_canal/canal_bridge_railing_01c"
    local MetalCol = Color(78,77,40,255)
    local PlasticMat = "sprops/textures/sprops_rubber2"
    local PlasticCol = Color(30,30,30,255)
    local EmptyModel = "models/sprops/misc/empty.mdl"
    --This holds information about all the models that make up the motion tracker as a whole, since it isn't a single mesh.
    --Just collapse this table, you don't need to read it, it just takes up screen space.
    local Holos = {
        {
            Pos = chip():getPos(),
            Ang = chip():localToWorldAngles(Angle(0, 90, 0)),
            Model = EmptyModel,
            Scale = Vector(0),
            Mat = "",
            Color = Color(0,0,0,0),
            Parent = chip()
        },
        {
            Model = "models/props_c17/oildrum001.mdl",
            Scale = Vector(0.06,0.06,0.2),
            Parent = 1,
            Mat = PlasticMat,
            Color = PlasticCol,
            Pos = chip():getPos(),
            Ang = chip():getAngles()
        },
        {
            Model = "models/sprops/rectangles/size_1_5/rect_6x12x3.mdl",
            Scale = Vector(0.5,0.4,0.2),
            Ang = chip():localToWorldAngles(Angle(0,90,0)),
            Pos = chip():localToWorld(Vector(0,1.7,0)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol
        },
        {
            Model = "models/sprops/geometry/hhex_12.mdl",
            Scale = Vector(0.3,0.2,0.4),
            Ang = chip():localToWorldAngles(Angle(0,-90,90)),
            Pos = chip():localToWorld(Vector(-2.24,0.5,0)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol
        },
        {
            Model = "models/sprops/rectangles/size_1_5/rect_6x12x3.mdl",
            Scale = Vector(0.74,0.4,0.2),
            Ang = chip():localToWorldAngles(Angle(90,0,90)),
            Pos = chip():localToWorld(Vector(0,4.4,4.6)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol
        },
        {
            Model = "models/Items/BoxSRounds.mdl",
            Scale = Vector(1.2,0.5,0.4),
            Ang = chip():localToWorldAngles(Angle(0,0,90)),
            Pos = chip():localToWorld(Vector(0,8.9,4.6)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol + Color(12,12,12)
        },
        {
            Model = "models/sprops/geometry/fhex_12.mdl",
            Scale = Vector(0.3,0.3,0.3),
            Ang = chip():localToWorldAngles(Angle(0,0,90)),
            Pos = chip():localToWorld(Vector(0,0,9)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol
        },
        {
            Model = "models/sprops/rectangles/size_1_5/rect_6x12x3.mdl",
            Scale = Vector(0.7,0.4,0.2),
            Ang = chip():localToWorldAngles(Angle(0,0,0)),
            Pos = chip():localToWorld(Vector(0,0,9.7)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol  
        },
        {
            Model = "models/sprops/rectangles/size_1_5/rect_6x12x3.mdl",
            Scale = Vector(0.5,0.4,0.2),
            Ang = chip():localToWorldAngles(Angle(90,0,0)),
            Pos = chip():localToWorld(Vector(-3.93,0,12.9)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol
        },
        {
            Model = "models/props_lab/monitor01b.mdl",
            Scale = Vector(0.3,0.45,0.47),
            Ang = chip():localToWorldAngles(Angle(0,-90,180)),
            Pos = chip():localToWorld(Vector(0,0.5,13.49)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol
        },
        {
            Model = "models/props_phx/construct/metal_wire1x1.mdl",
            Scale = Vector(0.13,0.12,0.6),
            Ang = chip():localToWorldAngles(Angle(0,0,90)),
            Pos = chip():localToWorld(Vector(0,1,13.4)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol
        },
        {
            Model = "models/props_wasteland/light_spotlight02_lamp.mdl",
            Scale = Vector(0.8,0.45,0.45),
            Ang = chip():localToWorldAngles(Angle(0,-90,180)),
            Pos = chip():localToWorld(Vector(0,4,12.9)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol
        },
        {
            Model = "models/props_lab/tpplugholder_single.mdl",
            Scale = Vector(0.35,0.28,0.25),
            Ang = chip():localToWorldAngles(Angle(0,90,180)),
            Pos = chip():localToWorld(Vector(-3.7,1,15)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol
        },
        {
            Model = "models/Items/BoxSRounds.mdl",
            Scale = Vector(1,0.4,0.35),
            Ang = chip():localToWorldAngles(Angle(0,0,90)),
            Pos = chip():localToWorld(Vector(0,8.9,8)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol + Color(12,12,12)
        },
        {
            Model = "models/sprops/geometry/hhex_12.mdl",
            Scale = Vector(0.2,0.2,0.2),
            Ang = chip():localToWorldAngles(Angle(0,-90,0)),
            Pos = chip():localToWorld(Vector(-3.93,0,16.35)),
            Parent = 1,
            Mat = MetalMat,
            Color =  MetalCol
        },
        {
            Model = "models/sprops/geometry/fhex_12.mdl",
            Scale = Vector(0.08, 0.2, 0.08),
            Ang = chip():localToWorldAngles(Angle(0,0,0)),
            Pos = chip():localToWorld(Vector(0,4,3)),
            Parent = 1,
            Mat = "sprops/textures/gear_metal",
            Color = Color(70,70,70,255),
        },
        {
            Model = "models/sprops/geometry/fhex_12.mdl",
            Scale = Vector(0.08, 0.2, 0.08),
            Ang = chip():localToWorldAngles(Angle(0,0,0)),
            Pos = chip():localToWorld(Vector(0,4,6)),
            Parent = 1,
            Mat = "sprops/textures/gear_metal",
            Color = Color(70,70,70,255),
        },
        {
            Model = "models/props_wasteland/light_spotlight01_lamp.mdl",
            Scale = Vector(0.06,0.1,0.1),
            Ang = chip():localToWorldAngles(Angle(0,0,90)),
            Pos = chip():localToWorld(Vector(-4.4,0.2,12)),
            Parent = 1,
            Mat = PlasticMat,
            Color =  PlasticCol
        },
        {
            Model = "models/props_wasteland/light_spotlight01_lamp.mdl",
            Scale = Vector(0.06,0.08,0.08),
            Ang = chip():localToWorldAngles(Angle(0,0,90)),
            Pos = chip():localToWorld(Vector(-4.4,0.2,15)),
            Parent = 1,
            Mat = PlasticMat,
            Color =  PlasticCol
        },
        {
            Model = "models/holograms/plane.mdl",
            Scale = Vector(0.38),
            Ang = chip():localToWorldAngles(Angle(90,-90,0)),
            Pos = chip():localToWorld(Vector(0,-2.3,13.4)),
            Parent = 1,
            Color = Color(150),
            Mat = ""
        },
        {
            Model = "models/bull/buttons/toggle_switch.mdl",
            Scale = Vector(0.5),
            Pos = chip():localToWorld(Vector(3,-1.2,13.5)),
            Ang = chip():localToWorldAngles(Angle(270, 180, 0)),
            Color = Color(255),
            Mat = "",
            Parent = 1
        }
    }
    
    local sfx = {
        hum = {
            "https:--www.dropbox.com/s/ish23nln7bipfqa/motiontracker_hum_1.ogg?dl=0",
            "https:--www.dropbox.com/s/u6d76zzu2ejdcv1/motiontracker_hum_2.ogg?dl=0",
            "https:--www.dropbox.com/s/qyvp5h2ogv6wcnd/motiontracker_hum_3.ogg?dl=0",
            "https:--www.dropbox.com/s/2eiyz0f2yxv9e3q/motiontracker_hum_4.ogg?dl=0",
            "https:--www.dropbox.com/s/621hjb40vxnsu3s/motiontracker_hum_5.ogg?dl=0",
            "https:--www.dropbox.com/s/nkbszs5gbmmtfov/motiontracker_hum_6.ogg?dl=0",
            "https:--www.dropbox.com/s/nmdll74iaygydfr/motiontracker_hum_7.ogg?dl=0",
            "https:--www.dropbox.com/s/7ys4pwn8aa2j7er/motiontracker_hum_8.ogg?dl=0",
            "https:--www.dropbox.com/s/gxvtx5dzxwnpule/motiontracker_hum_9.ogg?dl=0"
        },
        ambient = {"https:--www.dropbox.com/s/4jmsylhf4h484m4/MOTIONTRACKER_Sustained.ogg?dl=0"},
        bootup = {
            "https:--www.dropbox.com/s/88yy29hmp9i6qnr/Motion_Tracker_Startup_Short_01.ogg?dl=0",
            "https:--www.dropbox.com/s/sh3ebpqaa1n42ar/Motion_Tracker_Startup_Short_02.ogg?dl=0"
        },
        on = {
            "https:--www.dropbox.com/s/99woz2g3y0z0hkd/MOTIONTRACKER_On_01.ogg?dl=0",
            "https:--www.dropbox.com/s/xnjycippyqhzj56/MOTIONTRACKER_On_02.ogg?dl=0",
            "https:--www.dropbox.com/s/i2hm5vjtcb99iea/MOTIONTRACKER_On_03.ogg?dl=0"
        },
        initialpulse = {"https:--www.dropbox.com/s/ufd8u673rzldob0/motiontracker_initialpulse.ogg?dl=0"},
        pulse = {"https:--www.dropbox.com/s/tnclqrw0x3jkt75/motiontracker_secondary_pulse.ogg?dl=0"}
    }
    
    local loadedSounds = 0
    
    --createSound lib made by Cheezus
    --Create a custom sound object to work with both web and local sounds
    --Would use bass.loadFile but it doesn't seem to play wav files
    local function createSound(ent, path, onCreated)
        local snd = {}
        onCreated = onCreated or function() end
        snd.web = string.find(path, "https:--") and true or false
    
        function snd:play()
            if not snd.obj then return end
            snd.obj:play()
    
            if snd.web then
                hook.add("think", tostring(snd), function()
                    snd.obj:setPos(ent:getPos())
                end)
            end
        end
    
        function snd:stop()
            if not snd.obj then return end
    
            if snd.web then
                snd.obj:pause()
                snd.obj:setTime(0)
                hook.remove("think", tostring(snd))
            else
                snd.obj:stop()
            end
        end
    
        function snd:isValid()
            return snd.obj and true or false
        end
    
        function snd:setPitch(pitch)
            if not snd.obj then return end
            pitch = pitch * (snd.web and 1 or 100)
            snd.obj:setPitch(pitch)
        end
    
        function snd:setVolume(volume)
            if not snd.obj then return end
            snd.obj:setVolume(volume)
        end
    
        if snd.web then
            bass.loadURL(path, "3d noblock noplay", function(s)
                if not s then return end
                s:setLooping(false)
                snd.obj = s
                onCreated(snd)
            end)
        else
            snd.obj = sounds.create(ent, path)
            onCreated(snd)
        end
    
        return snd
    end
    
    local function playSound(bank)
        local count = #(bank)
        local rand = math.random(1, count)
        bank[rand]:play()
    end
    
    local function checkFinishedLoading()
        if player() != owner() then return end
        if loadedSounds == 17 then
            notification.kill("loading")
        end
        if matsLoaded == numMats then
           notification.kill("matsLoading") 
        end
        if loadedSounds == 17 and matsLoaded == numMats then
            notification.kill("loading")
            notification.kill("holosLoading")
            print("Finished loading all assets.")
            timer.simple(1, function()
                print("Equip hands to use Motion Tracker.")
            end)
        end
    end
    
    --Load all sounds.
    if player() == owner() then
        notification.addProgress("loading", "Loading sounds... (0/17)")
        notification.addProgress("matsLoading", "Loading Materials... ("..tostring(matsLoaded).."/"..tostring(numMats)..")")
    end
    
    --Material loading for screen display
    --Hemi-circle
    local curve = material.create("UnlitGeneric")
    curve:setTextureURL("$basetexture", "https:--dl.dropboxusercontent.com/s/9uxj8dmijc76vtr/bergus.png", nil, function(mat, url)
        matsLoaded = matsLoaded + 1
        if player() == owner() then
            notification.addProgress("matsLoading", "Loading Materials... ("..tostring(matsLoaded).."/"..tostring(numMats)..")")
        end
        checkFinishedLoading()
        return mat
    end)
    
    local radarCone = material.create("UnlitGeneric")
    radarCone:setTextureURL("$basetexture", "https:--dl.dropboxusercontent.com/s/ohzjeks91r71f9o/RadarCone.png", nil, function(mat, url)
        matsLoaded = matsLoaded + 1
        if player() == owner() then
            notification.addProgress("matsLoading", "Loading Materials... ("..tostring(matsLoaded).."/"..tostring(numMats)..")")
        end
        checkFinishedLoading()
        return mat
    end)
    
    local radarLeft = material.create("UnlitGeneric")
    radarLeft:setTextureURL("$basetexture", "https:--dl.dropboxusercontent.com/s/up9bxl8a0s0l7d7/RadarLeft.png", nil, function(mat, url)
        matsLoaded = matsLoaded + 1
        if player() == owner() then
            notification.addProgress("matsLoading", "Loading Materials... ("..tostring(matsLoaded).."/"..tostring(numMats)..")")
        end
        checkFinishedLoading()
        return mat
    end)
    
    local radarRight = material.create("UnlitGeneric")
    radarRight:setTextureURL("$basetexture", "https:--dl.dropboxusercontent.com/s/y9s37wfjk3iduz7/RadarRight.png", nil, function(mat, url)
        matsLoaded = matsLoaded + 1
        if player() == owner() then
            notification.addProgress("matsLoading", "Loading Materials... ("..tostring(matsLoaded).."/"..tostring(numMats)..")")
        end
        checkFinishedLoading()
        return mat
    end)
    
    local radarBehind = material.create("UnlitGeneric")
    radarBehind:setTextureURL("$basetexture", "https:--dl.dropboxusercontent.com/s/lbgrb6218ex5z7e/RadarBehind.png", nil, function(mat, url)
        matsLoaded = matsLoaded + 1
        if player() == owner() then
            notification.addProgress("matsLoading", "Loading Materials... ("..tostring(matsLoaded).."/"..tostring(numMats)..")")
        end
        checkFinishedLoading()
        return mat
    end)
    
    --Load in all sounds
    for k, sound in pairs(sfx) do
        for _, soundPath in pairs(sfx[k]) do
            soundPath = string.replace(soundPath, "www.dropbox.com", "dl.dropboxusercontent.com")
            soundPath = string.replace(soundPath, "?dl=0", "")
            sfx[k][_] = createSound(owner(), soundPath, function(s)
                loadedSounds = loadedSounds + 1
                if player() == owner() then notification.addProgress("loading", "Loading sounds... ("..loadedSounds.."/17)") end
                checkFinishedLoading()
            end)
        end
    end
    
    if player() == owner() then
        --Generate holograms from table.
        for _, holo in ipairs(Holos) do
            if not (holo.Pos and holo.Ang and holo.Scale and holo.Color and holo.Model and holo.Parent and holo.Mat) then print("Hologram "..tostring(_).." does not have all required fields!") continue end
            local newHolo = holograms.create(holo.Pos, holo.Ang, holo.Model, holo.Scale)
            newHolo:setMaterial(holo.Mat)
            newHolo:setColor(Color(holo.Color[1], holo.Color[2], holo.Color[3], holo.Alpha or 255))
            if type(holo.Parent) != "number" then
                newHolo:setParent(holo.Parent)
            else
                newHolo:setParent(Holos[holo.Parent])
            end
            newHolo:setColor(Color(255,255,255,1))
            Holos[_] = newHolo
        end
        
        render.createRenderTarget("canvas")
        Holos[20]:setMaterial("!" .. screenMat:getName())
    end
    
    local isActive = false
    local isFirstEquip = true
    local oldTargets = {}
    local moving = {}
    local pulse = sfx.pulse[1]
    local minSpeed = 1
    local distCoef = 1.0
    local range = 787.401575
    hook.add("Tick", "octoAIMTTick", function()
        if isValid(owner():getActiveWeapon()) and owner():getActiveWeapon():getPrintName() == "hands" then
            if not isActive then
                if isFirstEquip then
                    playSound(sfx.bootup)
                    isFirstEquip = false
                    isActive = true
                else
                    playSound(sfx.on)
                    isActive = true
                end
            end
        else
            if isActive then
                playSound(sfx.on)
                isActive = false
                oldTargets = {}
            end
        end
        
        --Owner only holos
        if player() == owner() then
            Holos[1]:setAngles(owner():getEyeAngles())
            if owner():isCrouching() then
                Holos[1]:setPos(owner():getPos() + Vector(0,0,40))
            else
                Holos[1]:setPos(owner():getPos() + Vector(0,0,80))
            end
        end
        
        if isActive then
            --Find moving entities within a in 20 meter sphere
            local movingTargets = 0
            moving = {}
            local targets = find.inSphere(owner():getPos(), range, function(ent)
                if ent == owner() then return false end
                if isValid(ent) and (ent:getVelocity():getLength() > 0 or (type(ent) == "Player" and ent:isAlive()) or (type(ent) == "Npc" and ent:getHealth() > 0) or type(ent) == "Vehicle") then
                    if ent:getVelocity():getLength() > minSpeed then
                        movingTargets = movingTargets + 1
                        moving[#moving+1] = ent
                    end
                    return true
                end
                return false
            end)
            if #oldTargets < movingTargets then playSound(sfx.initialpulse) end
            oldTargets = table.copy(targets)
            
            --Don't proceed with anything if nothing is in range.
            if #moving == 0 then
                distCoef = -1
                return
            end
            
            --Detect who all is moving and give each a dot.
            for _,ent in pairs(moving) do
                if ent:getVelocity():getLength() > minSpeed then
                    
                end
            end
            
            --Get closest ent to the owner.
            local closest = find.closest(moving, owner():getPos())
            --Number between 0 and 1 for range from owner of the closest target.
            distCoef = math.clamp(math.round(closest:getPos():getDistance(owner():getPos())/range,2), 0, 1)
            
            pulse:setPitch(math.remap(1-distCoef, 0, 1, 0.97, 1.08) + math.rand(-0.008,0.008))
            if (timer.curtime() - lastPulse) >= 0.33+distCoef*0.66 then
                pulse:play()
                lastPulse = timer.curtime()
            end
        end
    end) 
    
    local width, height
    local shouldDraw = true
    local TextFont = render.createFont("DejaVu Sans Mono", 64)
    hook.add("drawhud", "drawstuff", function()
        if player() != owner() or not isActive then return end
        if width == nil or height == nil then width, height = render.getResolution() end
        
        --/ DRAW THE MOTION TRACKER SCREEN TO THE OWNER'S HUD --/
        -- Render the screen at half the FPS of the owner's game FPS
        if shouldDraw then
            -- You can also get difference in these frames by subtracting now from last_frame,
            -- Or if you only need that, just use timer.frametime rather than storing the frames.
        
            render.selectRenderTarget("screenRT") -- select our render target
                render.clear() -- clear the screen, if we don't do this then whatever we draw will be drawn on top of our last frame
                
                --Draw the distance coefficient number.
                render.setColor(Color(52,74,47,255))
                render.drawRectFast(0,0,1024,1024)
                render.setColor(Color(158,253,152,255))
                if distCoef != -1 then
                    render.setFont(TextFont)
                    render.drawSimpleText(70, 939, string.format("%.2f", distCoef), TEXT_ALIGN.LEFT, TEXT_ALIGN.BOTTOM)
                end
                render.setMaterial(radarCone)
                render.setColor(Color(255,255,255,255))
                render.drawTexturedRectFast(66,30,890,890)
                
                for _,v in pairs(moving) do
                    local pos = worldToLocal(v:getPos(),Angle(0,0,0),owner():getPos(),owner():getAngles()*Angle(0,1,0) + Angle(0,-90,0))
                       local bearing = (180/math.pi)*-math.atan2(pos[2], pos[1])
                    if bearing > -117 and bearing < -63 then
                        render.setColor(Color(158,253,152,255))
                        render.drawFilledCircle(412+math.remap(pos[1], 0, range, 100, 924), 775-math.remap(pos[2], 0, range, 0, 660)+math.abs((bearing+90)*1.75*distCoef), 20)
                    elseif (math.sign(bearing) == -1 and bearing < -117) or  (math.sign(bearing) == 1 and bearing > 153) then --Left
                        render.setMaterial(radarLeft)
                        render.setColor(Color(255,255,255,255))
                        render.drawTexturedRectFast(66,30,890,890)
                    elseif bearing > -63 and bearing < 28 then --Right
                        render.setMaterial(radarRight)
                        render.setColor(Color(255,255,255,255))
                        render.drawTexturedRectFast(66,30,890,890)
                    else --Behind
                        render.setMaterial(radarBehind)
                        render.setColor(Color(255,255,255,255))
                        render.drawTexturedRectFast(66,30,890,890)
                    end
                end
        end
        shouldDraw = !shouldDraw
        
        --render.setRenderTargetTexture("screenRT")
        --render.drawTexturedRectRotatedFast(width/5, height-(width/4.35), width/8, width/8, -8)
        
        render.selectRenderTarget("canvas")
            render.clear(Color(0,0,0,0), true)
            
            render.pushViewMatrix({
                type = "3D",
                origin = Holos[1]:localToWorld(Vector(-22.5, -4, 13.5)),
                angles = Holos[1]:localToWorldAngles(Angle(-3,6,-8)),
                fov = 50,
                aspect = 1,
            })
            
            -- This is the simplest way of combating weird lighting issues
            -- It doesn't work for all models though, ragdolls in particular
            -- Value for this function can be 1 (total fullbright) or 2 (increased fullbright), depending on the needs
            for _,v in pairs(Holos) do
                if _ == 20 then
                    render.setLightingMode(2)
                else
                    render.setLightingMode(0)
                end
                v:draw()
            end
            
            render.popViewMatrix()
        render.selectRenderTarget()
        
        render.setColor(Color(255,255,255))
        render.setRenderTargetTexture("canvas")
        render.drawTexturedRect(0, height-(width/2), width/2, width/2)
    end)
    
    if player() == owner() then
        enableHud(nil, true)
    end
end

--Make all of the prints fancy
local oldPrint = print

function print(...)
    oldPrint(Color(100, 255, 100), "[Motion Tracker SWEP] ", Color(255, 255, 255), ...)
end
