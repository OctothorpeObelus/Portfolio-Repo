--@name SWEP Base
--@author Octo
--@shared

--[[
    This is a simple Scripted Weapon (SWEP) base for starfall use.
    Originally created for use int he TF2 Rocket Launcher, but a broad base for general use elsewhere.
]]

SWEP = {}
SWEP.CamPos = Vector(0,0,0)
SWEP.CamAng = Angle(0,0,0)
SWEP.FOV = 80
SWEP.nextAttackTime = timer.systime()

local swepuser = owner()

--Set the weapon viewmodel
function setVModel(path)
    if SERVER or player() != swepuser then return end
    SWEP.Viewmodel = path
    if isValid(SWEP.VMHolo) then SWEP.VMHolo:remove() end
    SWEP.VMHolo = holograms.create(swepuser:getEyePos(), swepuser:getEyeAngles(), SWEP.Viewmodel)
    SWEP.VMHolo:setParent(nil)
    SWEP.VMHolo:setColor(Color(255, 255, 255, 1))
end

--Set the owner of the SWEP
function setSWEPUser(ply, path)
    if ply:isPlayer() then
        swepuser = ply
        setVModel(path)
        if CLIENT then
            if not render.renderTargetExists("canvas") then render.createRenderTarget("canvas") end
        end
    end
end

--Handle rendering of the weapon viewmodel via render target
function renderVModel()
    if SERVER then return end
    local width, height = render.getResolution()
    if player() != swepuser then return end
    
    render.selectRenderTarget("canvas")
        render.clear(Color(0,0,0,0), true)
        
        render.pushViewMatrix({
            type = "3D",
            origin = SWEP.VMHolo:localToWorld(SWEP.CamPos),
            angles = SWEP.VMHolo:localToWorldAngles(SWEP.CamAng),
            fov = SWEP.FOV,
            aspect = width/height,
        })
        
        SWEP.VMHolo:draw()
        
        render.popViewMatrix()
    render.selectRenderTarget()
    
    render.setColor(Color(255,255,255))
    render.setRenderTargetTexture("canvas")
    --render.drawTexturedRect(0, 0, width, height)
    render.drawTexturedRect(0, 0, width+1, height+1)
    
    if not isValid(SWEP.VMHolo) or player() != swepuser then return end
    
    SWEP.VMHolo:setAngles(swepuser:getEyeAngles())
    SWEP.VMHolo:setPos(swepuser:getEyePos())
end

--Set the currently running animation sequence of the viewmodel
--Takes in a sequence name, frame to start at, and the playback rate
function setVSequence(anim, frame, rate)
    if SERVER or player() != swepuser then return end
    SWEP.VMHolo:setAnimation(anim, frame or nil, rate or nil)
end

function SWEPCanFire()
    if SWEP.Clip1 <= 0 then return false end
    if timer.systime() < SWEP.nextAttackTime then return false end
    if SWEP.Locked then return false end
    return true
end

if SERVER then
    --This lamp is needed to fix a strange issue with rendertargets that otherwise
    --cause rendered viewmodels to be extremely transparent. Changing Z planes did not appear to resolve this, either.
    local lamp = prop.createSent(chip():getPos() + Vector(0,0,75), Angle(90,0,0), "gmod_lamp", true, {
        on = true,
        brightness = 0,
        fov = 360,
        Model = "models/maxofs2d/lamp_flashlight.mdl",
    })
    lamp:setColor(Color(0,0,0,0))
    lamp:setCollisionGroup(10) -- COLLISION_GROUP_IN_VEHICLE
    hook.add("tick", "octoSWEPBaseTick", function()
        if not isValid(lamp) then return end
        lamp:setPos(swepuser:getPos() + Vector(0,0,512))
    end)
else
    if player() != swepuser then return end
    render.createRenderTarget("canvas")
end