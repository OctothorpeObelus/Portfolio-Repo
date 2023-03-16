--@name Bell Crank Suspension Animator (Type 97 Style)
--@author Octo
--@server

-- Wire Port Setup.
wire.adjustInputs({"Baseplate", "Wheels"}, {"entity", "array"})-- Wheels should be associated with the Adv Entity Marker in the correct order, front to rear on both sides, starting on the left side.

--Variables.
local Wheels = {}
local Holos = {}
local Baseplate = nil
local mat = "models/props_c17/metalladder001"
local col = Color(82*1.4, 81*1.4, 45*1.4, 255)

--Wire inputs and hologram setup.
hook.add("input", "octoBCSAInput", function(which, val)
    if which == "Wheels" then
        if #wire.ports.Wheels != 12 then return end --Incorrect number of wheels.
        
        for k,v in pairs(wire.ports.Wheels) do
            if not isValid(v) then
                Wheels = {}
                return
            end --Not all wheels are valid entites.
        end
        
        Wheels = wire.ports.Wheels --Everything was successful, transfer the wire input to a table.
        
    end
    
    if Wheels != {} and isValid(wire.ports.Baseplate) then
        --Make the roots for the animation, then place the visual holograms on top of those roots.
        Baseplate = wire.ports.Baseplate
        local cube = "models/holograms/cube.mdl"
        local scale = Vector(0)
        
        holograms.removeAll()--Delete all previously created holos.
        Holos = {}
        
        if holograms.hologramsLeft() < 172 then error("Server hologram budget not sufficient enough to create suspension. ("..tostring(holograms.hologramsLeft()).." < 172)", 0) end
        
        --Create the skeleton rig with which to control the entire setup
        --Bogeys between the wheel pairs.
        Holos["lf_bogey"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal((Wheels[2]:getPos()+Wheels[3]:getPos())/2) + Vector(0, 0, 3.5) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Left Front Wheel Bogey
        Holos["lr_bogey"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal((Wheels[4]:getPos()+Wheels[5]:getPos())/2) + Vector(0, 0, 3.5) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Left Rear Wheel Bogey
        Holos["rf_bogey"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal((Wheels[8]:getPos()+Wheels[9]:getPos())/2) + Vector(0, 0, 3.5) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Right Front Wheel Bogey
        Holos["rr_bogey"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal((Wheels[10]:getPos()+Wheels[11]:getPos())/2) + Vector(0, 0, 3.5) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Right Rear Wheel Bogey
        Holos["lf_bogey"]:setParent(Baseplate)
        Holos["lr_bogey"]:setParent(Baseplate)
        Holos["rf_bogey"]:setParent(Baseplate)
        Holos["rr_bogey"]:setParent(Baseplate)
        
        --Bell Crank arms for each wheel/pair of wheels.
        Holos["lf_crank_s"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal(Wheels[1]:getPos()) + Vector(12, -9, 8) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Left Front Bell Crank (Single Wheel)
        Holos["lr_crank_s"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal(Wheels[6]:getPos()) + Vector(-12, -9, 8) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Left Rear Bell Crank (Single Wheel)
        Holos["rf_crank_s"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal(Wheels[7]:getPos()) + Vector(12, 9, 8) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Right Front Bell Crank (Single Wheel)
        Holos["rr_crank_s"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal(Wheels[12]:getPos()) + Vector(-12, 9, 8) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Right Rear Bell Crank (Single Wheel)
        Holos["lf_crank_s"]:setParent(Baseplate)
        Holos["lr_crank_s"]:setParent(Baseplate)
        Holos["rf_crank_s"]:setParent(Baseplate)
        Holos["rr_crank_s"]:setParent(Baseplate)
        
        --Now each crank for the pairs.
        Holos["lf_crank"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal((Wheels[2]:getPos()+Wheels[3]:getPos())/2) + Vector(14, -9, 8) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Left Front Bogey Bell Crank
        Holos["lr_crank"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal((Wheels[4]:getPos()+Wheels[5]:getPos())/2) + Vector(-14, -9, 8) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Left Rear Bogey Bell Crank
        Holos["rf_crank"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal((Wheels[8]:getPos()+Wheels[9]:getPos())/2) + Vector(14, 9, 8) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Right Front Bogey Bell Crank
        Holos["rr_crank"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal((Wheels[10]:getPos()+Wheels[11]:getPos())/2) + Vector(-14, 9, 8) ), Baseplate:localToWorldAngles( Angle(0) ), cube, scale )--Right Rear Bogey Bell Crank
        Holos["lf_crank"]:setParent(Baseplate)
        Holos["lr_crank"]:setParent(Baseplate)
        Holos["rf_crank"]:setParent(Baseplate)
        Holos["rr_crank"]:setParent(Baseplate)
        
        --Spring Anchors
        Holos["l_anchor"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal((Wheels[3]:getPos()+Wheels[4]:getPos())/2) + Vector(0, -8.5, 15.5) ), Baseplate:getAngles(), cube, scale )
        Holos["r_anchor"] = holograms.create( Baseplate:localToWorld( Baseplate:worldToLocal((Wheels[9]:getPos()+Wheels[10]:getPos())/2) + Vector(0, 8.5, 15.5) ), Baseplate:getAngles(), cube, scale )
        Holos["lf_anchor"] = holograms.create( Baseplate:getPos(), Baseplate:getAngles(), cube, scale )
        Holos["lr_anchor"] = holograms.create( Baseplate:getPos(), Baseplate:getAngles(), cube, scale )
        Holos["rf_anchor"] = holograms.create( Baseplate:getPos(), Baseplate:getAngles(), cube, scale )
        Holos["rr_anchor"] = holograms.create( Baseplate:getPos(), Baseplate:getAngles(), cube, scale )
        Holos["l_anchor"]:setParent(Baseplate)
        Holos["r_anchor"]:setParent(Baseplate)
        Holos["lf_anchor"]:setParent(Baseplate)
        Holos["lr_anchor"]:setParent(Baseplate)
        Holos["rf_anchor"]:setParent(Baseplate)
        Holos["rr_anchor"]:setParent(Baseplate)
        
        --Make the visual models (suffixed with _v in the index).
        --Bogies
        --Left Front Bogey Visuals
        local lf_b = holograms.create( Holos["lf_bogey"]:localToWorld( Vector(0, 0, -0.5) ), Holos["lf_bogey"]:localToWorldAngles( Angle(45, 0, 0) ), "models/sprops/geometry/qring_12.mdl", Vector(2, 0.65, 2) )
            local cyl = holograms.create( Holos["lf_bogey"]:localToWorld( Vector(0, -1.85, 0) ), Holos["lf_bogey"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_2/cylinder_3x6.mdl", Vector(1.45, 1.45, 1.82) )
            local hex = holograms.create( Holos["lf_bogey"]:localToWorld( Vector(0, 4.2, 0) ), Holos["lf_bogey"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/fhex_12.mdl", Vector(0.3, 0.4, 0.3) )
            lf_b:setMaterial(mat)
            cyl:setMaterial(mat)
            hex:setMaterial(mat)
            lf_b:setColor(col)
            cyl:setColor(col)
            hex:setColor(col)
            lf_b:setParent(Holos["lf_bogey"])
            cyl:setParent(lf_b)
            hex:setParent(lf_b)
        
        --Left Rear Bogey Visuals
        local lr_b = holograms.create( Holos["lr_bogey"]:localToWorld( Vector(0, 0, -0.5) ), Holos["lr_bogey"]:localToWorldAngles( Angle(45, 0, 0) ), "models/sprops/geometry/qring_12.mdl", Vector(2, 0.65, 2) )
            local cyl = holograms.create( Holos["lr_bogey"]:localToWorld( Vector(0, -1.85, 0) ), Holos["lr_bogey"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_2/cylinder_3x6.mdl", Vector(1.45, 1.45, 1.82) )
            local hex = holograms.create( Holos["lr_bogey"]:localToWorld( Vector(0, 4.2, 0) ), Holos["lr_bogey"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/fhex_12.mdl", Vector(0.3, 0.4, 0.3) )
            lr_b:setMaterial(mat)
            cyl:setMaterial(mat)
            hex:setMaterial(mat)
            lr_b:setColor(col)
            cyl:setColor(col)
            hex:setColor(col)
            lr_b:setParent(Holos["lr_bogey"])
            cyl:setParent(lr_b)
            hex:setParent(lr_b)
            
        --Right Front Bogey Visuals
        local rf_b = holograms.create( Holos["rf_bogey"]:localToWorld( Vector(0, 0, -0.5) ), Holos["rf_bogey"]:localToWorldAngles( Angle(45, 0, 0) ), "models/sprops/geometry/qring_12.mdl", Vector(2, 0.65, 2) )
            local cyl = holograms.create( Holos["rf_bogey"]:localToWorld( Vector(0, 1.85, 0) ), Holos["rf_bogey"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_2/cylinder_3x6.mdl", Vector(1.45, 1.45, 1.82) )
            local hex = holograms.create( Holos["rf_bogey"]:localToWorld( Vector(0, -4.2, 0) ), Holos["rf_bogey"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/fhex_12.mdl", Vector(0.3, 0.4, 0.3) )
            rf_b:setMaterial(mat)
            cyl:setMaterial(mat)
            hex:setMaterial(mat)
            rf_b:setColor(col)
            cyl:setColor(col)
            hex:setColor(col)
            rf_b:setParent(Holos["rf_bogey"])
            cyl:setParent(rf_b)
            hex:setParent(rf_b)
        
        --Right Rear Bogey Visuals
        local rr_b = holograms.create( Holos["rr_bogey"]:localToWorld( Vector(0, 0, -0.5) ), Holos["rr_bogey"]:localToWorldAngles( Angle(45, 0, 0) ), "models/sprops/geometry/qring_12.mdl", Vector(2, 0.65, 2) )
            local cyl = holograms.create( Holos["rr_bogey"]:localToWorld( Vector(0, 1.85, 0) ), Holos["rr_bogey"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_2/cylinder_3x6.mdl", Vector(1.45, 1.45, 1.82) )
            local hex = holograms.create( Holos["rr_bogey"]:localToWorld( Vector(0, -4.2, 0) ), Holos["rr_bogey"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/fhex_12.mdl", Vector(0.3, 0.4, 0.3) )
            rr_b:setMaterial(mat)
            cyl:setMaterial(mat)
            hex:setMaterial(mat)
            rr_b:setColor(col)
            cyl:setColor(col)
            hex:setColor(col)
            rr_b:setParent(Holos["rr_bogey"])
            cyl:setParent(rr_b)
            hex:setParent(rr_b)
            
        --Bell Cranks
        --Left Front Crank Visuals
        Holos["lf_crank_v"] = holograms.create( Holos["lf_crank"]:localToWorld( Vector(0, 0.5, 0) ), Holos["lf_crank"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_4/cylinder_9x3.mdl", Vector(1, 1, 1) )
            local lbar = holograms.create( Holos["lf_crank"]:localToWorld( Vector(-8.5, 1.5, -2.3) ), Holos["lf_crank"]:localToWorldAngles( Angle(-24.5, -12, 90) ), "models/sprops/rectangles_thin/size_1/rect_3x18x1_5.mdl", Vector(0.7, 1.2, 1.2) )
            local hbar1 = holograms.create( Holos["lf_crank"]:localToWorld( Vector(0, 0.5, 5.45) ), Holos["lf_crank"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/rectangles/size_1_5/rect_6x6x3.mdl", Vector(0.75, 0.542, 0.5) )
            local hbar2 = holograms.create( Holos["lf_crank"]:localToWorld( Vector(0, 0.5, 8.2) ), Holos["lf_crank"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.375) )
            Holos["lf_crank_nub"] = holograms.create( Holos["lf_crank"]:localToWorld( Vector(5.25, 0.5, 1.5) ), Holos["lf_crank"]:localToWorldAngles( Angle(75, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.6) )
            Holos["lf_crank_nub"]:setColor(col)
            Holos["lf_crank_nub"]:setMaterial(mat)
            Holos["lf_crank_nub"]:setParent(Holos["lf_crank"])
            Holos["lf_crank_v"]:setMaterial(mat)
            lbar:setMaterial(mat)
            hbar1:setMaterial(mat)
            hbar2:setMaterial(mat)
            Holos["lf_crank_v"]:setColor(col)
            lbar:setColor(col)
            hbar1:setColor(col)
            hbar2:setColor(col)
            Holos["lf_crank_v"]:setParent(Holos["lf_crank"])
            lbar:setParent(Holos["lf_crank"])
            hbar1:setParent(Holos["lf_crank"])
            hbar2:setParent(Holos["lf_crank"])
        
        --Right Front Crank Visuals
        Holos["rf_crank_v"] = holograms.create( Holos["rf_crank"]:localToWorld( Vector(0, -0.5, 0) ), Holos["rf_crank"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_4/cylinder_9x3.mdl", Vector(1, 1, 1) )
            local lbar = holograms.create( Holos["rf_crank"]:localToWorld( Vector(-8.5, -1.5, -2.3) ), Holos["rf_crank"]:localToWorldAngles( Angle(-24.5, 12, 90) ), "models/sprops/rectangles_thin/size_1/rect_3x18x1_5.mdl", Vector(0.7, 1.2, 1.2) )
            local hbar1 = holograms.create( Holos["rf_crank"]:localToWorld( Vector(0, -0.5, 5.45) ), Holos["rf_crank"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/rectangles/size_1_5/rect_6x6x3.mdl", Vector(0.75, 0.542, 0.5) )
            local hbar2 = holograms.create( Holos["rf_crank"]:localToWorld( Vector(0, -0.5, 8.2) ), Holos["rf_crank"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.375) )
            Holos["rf_crank_nub"] = holograms.create( Holos["rf_crank"]:localToWorld( Vector(5.25, -0.5, 1.5) ), Holos["rf_crank"]:localToWorldAngles( Angle(75, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.6) )
            Holos["rf_crank_nub"]:setColor(col)
            Holos["rf_crank_nub"]:setMaterial(mat)
            Holos["rf_crank_nub"]:setParent(Holos["rf_crank"])
            Holos["rf_crank_v"]:setMaterial(mat)
            lbar:setMaterial(mat)
            hbar1:setMaterial(mat)
            hbar2:setMaterial(mat)
            Holos["rf_crank_v"]:setColor(col)
            lbar:setColor(col)
            hbar1:setColor(col)
            hbar2:setColor(col)
            Holos["rf_crank_v"]:setParent(Holos["rf_crank"])
            lbar:setParent(Holos["rf_crank"])
            hbar1:setParent(Holos["rf_crank"])
            hbar2:setParent(Holos["rf_crank"])
            
        --Left Rear Crank Visuals
        Holos["lr_crank_v"] = holograms.create( Holos["lr_crank"]:localToWorld( Vector(0, 0.5, 0) ), Holos["lr_crank"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_4/cylinder_9x3.mdl", Vector(1, 1, 1) )
            local lbar = holograms.create( Holos["lr_crank"]:localToWorld( Vector(8.5, 1.5, -2.3) ), Holos["lr_crank"]:localToWorldAngles( Angle(24.5, 12, 90) ), "models/sprops/rectangles_thin/size_1/rect_3x18x1_5.mdl", Vector(0.7, 1.2, 1.2) )
            local hbar1 = holograms.create( Holos["lr_crank"]:localToWorld( Vector(0, 0.5, 5.45) ), Holos["lr_crank"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/rectangles/size_1_5/rect_6x6x3.mdl", Vector(0.75, 0.542, 0.5) )
            local hbar2 = holograms.create( Holos["lr_crank"]:localToWorld( Vector(0, 0.5, 8.2) ), Holos["lr_crank"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.375) )
            Holos["lr_crank_nub"] = holograms.create( Holos["lr_crank"]:localToWorld( Vector(-5.25, 0.5, 1.5) ), Holos["lr_crank"]:localToWorldAngles( Angle(-75, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.6) )
            Holos["lr_crank_nub"]:setColor(col)
            Holos["lr_crank_nub"]:setMaterial(mat)
            Holos["lr_crank_nub"]:setParent(Holos["lr_crank"])
            Holos["lr_crank_v"]:setMaterial(mat)
            lbar:setMaterial(mat)
            hbar1:setMaterial(mat)
            hbar2:setMaterial(mat)
            Holos["lr_crank_v"]:setColor(col)
            lbar:setColor(col)
            hbar1:setColor(col)
            hbar2:setColor(col)
            Holos["lr_crank_v"]:setParent(Holos["lr_crank"])
            lbar:setParent(Holos["lr_crank"])
            hbar1:setParent(Holos["lr_crank"])
            hbar2:setParent(Holos["lr_crank"])
        
        --Right Rear Crank Visuals
        Holos["rr_crank_v"] = holograms.create( Holos["rr_crank"]:localToWorld( Vector(0, -0.5, 0) ), Holos["rr_crank"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_4/cylinder_9x3.mdl", Vector(1, 1, 1) )
            local lbar = holograms.create( Holos["rr_crank"]:localToWorld( Vector(8.5, -1.5, -2.3) ), Holos["rr_crank"]:localToWorldAngles( Angle(24.5, -12, 90) ), "models/sprops/rectangles_thin/size_1/rect_3x18x1_5.mdl", Vector(0.7, 1.2, 1.2) )
            local hbar1 = holograms.create( Holos["rr_crank"]:localToWorld( Vector(0, -0.5, 5.45) ), Holos["rr_crank"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/rectangles/size_1_5/rect_6x6x3.mdl", Vector(0.75, 0.542, 0.5) )
            local hbar2 = holograms.create( Holos["rr_crank"]:localToWorld( Vector(0, -0.5, 8.2) ), Holos["rr_crank"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.375) )
            Holos["rr_crank_nub"] = holograms.create( Holos["rr_crank"]:localToWorld( Vector(-5.25, -0.5, 1.5) ), Holos["rr_crank"]:localToWorldAngles( Angle(-75, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.6) )
            Holos["rr_crank_nub"]:setColor(col)
            Holos["rr_crank_nub"]:setMaterial(mat)
            Holos["rr_crank_nub"]:setParent(Holos["rr_crank"])
            Holos["rr_crank_v"]:setMaterial(mat)
            lbar:setMaterial(mat)
            hbar1:setMaterial(mat)
            hbar2:setMaterial(mat)
            Holos["rr_crank_v"]:setColor(col)
            lbar:setColor(col)
            hbar1:setColor(col)
            hbar2:setColor(col)
            Holos["rr_crank_v"]:setParent(Holos["rr_crank"])
            lbar:setParent(Holos["rr_crank"])
            hbar1:setParent(Holos["rr_crank"])
            hbar2:setParent(Holos["rr_crank"])
            
        --Single cranks
        --Left Front Single Crank Visuals
        Holos["lf_crank_s_v"] = holograms.create( Holos["lf_crank_s"]:localToWorld( Vector(0, 0.5, 0) ), Holos["lf_crank_s"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_4/cylinder_9x3.mdl", Vector(1, 1, 1) )
            local lbar = holograms.create( Holos["lf_crank_s"]:localToWorld( Vector(-8.5, 1.5, -2.3) ), Holos["lf_crank_s"]:localToWorldAngles( Angle(-24.5, -12, 90) ), "models/sprops/rectangles_thin/size_1/rect_3x18x1_5.mdl", Vector(0.7, 1.2, 1.2) )
            local hbar1 = holograms.create( Holos["lf_crank_s"]:localToWorld( Vector(0, 0.5, 5.45) ), Holos["lf_crank_s"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/rectangles/size_1_5/rect_6x6x3.mdl", Vector(0.75, 0.542, 0.5) )
            local nub = holograms.create( Holos["lf_crank_s"]:localToWorld( Vector(0, 0.5, 8.2) ), Holos["lf_crank_s"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.375) )
            Holos["lf_crank_s_lbar2"] = holograms.create( Wheels[1]:localToWorld( Vector(0, -5, 0) ), Baseplate:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_3/cylinder_6x6.mdl", Vector(1, 1, 1) )
            Holos["lf_crank_s_v"]:setMaterial(mat)
            lbar:setMaterial(mat)
            hbar1:setMaterial(mat)
            nub:setMaterial(mat)
            Holos["lf_crank_s_lbar2"]:setMaterial(mat)
            Holos["lf_crank_s_v"]:setColor(col)
            lbar:setColor(col)
            hbar1:setColor(col)
            nub:setColor(col)
            Holos["lf_crank_s_lbar2"]:setColor(col)
            Holos["lf_crank_s_v"]:setParent(Holos["lf_crank_s"])
            lbar:setParent(Holos["lf_crank_s"])
            hbar1:setParent(Holos["lf_crank_s"])
            nub:setParent(Holos["lf_crank_s"])
            timer.simple(game.getTickInterval()*4, function()
                Holos["lf_crank_s_lbar2"]:setParent(Holos["lf_crank_s"])
            end)
        
        --Left Rear Single Crank Visuals
        Holos["lr_crank_s_v"] = holograms.create( Holos["lr_crank_s"]:localToWorld( Vector(0, 0.5, 0) ), Holos["lr_crank_s"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_4/cylinder_9x3.mdl", Vector(1, 1, 1) )
            local lbar = holograms.create( Holos["lr_crank_s"]:localToWorld( Vector(8.5, 1.5, -2.3) ), Holos["lr_crank_s"]:localToWorldAngles( Angle(24.5, 12, 90) ), "models/sprops/rectangles_thin/size_1/rect_3x18x1_5.mdl", Vector(0.7, 1.2, 1.2) )
            local hbar1 = holograms.create( Holos["lr_crank_s"]:localToWorld( Vector(0, 0.5, 5.45) ), Holos["lr_crank_s"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/rectangles/size_1_5/rect_6x6x3.mdl", Vector(0.75, 0.542, 0.5) )
            local hbar2 = holograms.create( Holos["lr_crank_s"]:localToWorld( Vector(0, 0.5, 8.2) ), Holos["lr_crank_s"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.375) )
            Holos["lr_crank_s_lbar2"] = holograms.create( Wheels[6]:localToWorld( Vector(0, -5, 0) ), Baseplate:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_3/cylinder_6x6.mdl", Vector(1, 1, 1) )
            Holos["lr_crank_s_v"]:setMaterial(mat)
            Holos["lr_crank_s_lbar2"]:setMaterial(mat)
            lbar:setMaterial(mat)
            hbar1:setMaterial(mat)
            hbar2:setMaterial(mat)
            Holos["lr_crank_s_v"]:setColor(col)
            Holos["lr_crank_s_lbar2"]:setColor(col)
            lbar:setColor(col)
            hbar1:setColor(col)
            hbar2:setColor(col)
            Holos["lr_crank_s_v"]:setParent(Holos["lr_crank_s"])
            lbar:setParent(Holos["lr_crank_s"])
            hbar1:setParent(Holos["lr_crank_s"])
            hbar2:setParent(Holos["lr_crank_s"])
            timer.simple(game.getTickInterval()*4, function()
                Holos["lr_crank_s_lbar2"]:setParent(Holos["lr_crank_s"])
            end)
        
        --Right Front Single Crank Visuals
        Holos["rf_crank_s_v"] = holograms.create( Holos["rf_crank_s"]:localToWorld( Vector(0, -0.5, 0) ), Holos["rf_crank_s"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_4/cylinder_9x3.mdl", Vector(1, 1, 1) )
            local lbar = holograms.create( Holos["rf_crank_s"]:localToWorld( Vector(-8.5, -1.5, -2.3) ), Holos["rf_crank_s"]:localToWorldAngles( Angle(-24.5, 12, 90) ), "models/sprops/rectangles_thin/size_1/rect_3x18x1_5.mdl", Vector(0.7, 1.2, 1.2) )
            local hbar1 = holograms.create( Holos["rf_crank_s"]:localToWorld( Vector(0, -0.5, 5.45) ), Holos["rf_crank_s"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/rectangles/size_1_5/rect_6x6x3.mdl", Vector(0.75, 0.542, 0.5) )
            local hbar2 = holograms.create( Holos["rf_crank_s"]:localToWorld( Vector(0, -0.5, 8.2) ), Holos["rf_crank_s"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.375) )
            Holos["rf_crank_s_lbar2"] = holograms.create( Wheels[7]:localToWorld( Vector(0, -5, 0) ), Baseplate:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_3/cylinder_6x6.mdl", Vector(1, 1, 1) )
            Holos["rf_crank_s_lbar2"]:setMaterial(mat)
            Holos["rf_crank_s_v"]:setMaterial(mat)
            lbar:setMaterial(mat)
            hbar1:setMaterial(mat)
            hbar2:setMaterial(mat)
            Holos["rf_crank_s_lbar2"]:setColor(col)
            Holos["rf_crank_s_v"]:setColor(col)
            lbar:setColor(col)
            hbar1:setColor(col)
            hbar2:setColor(col)
            Holos["rf_crank_s_v"]:setParent(Holos["rf_crank_s"])
            lbar:setParent(Holos["rf_crank_s"])
            hbar1:setParent(Holos["rf_crank_s"])
            hbar2:setParent(Holos["rf_crank_s"])
            timer.simple(game.getTickInterval()*4, function()
                Holos["rf_crank_s_lbar2"]:setParent(Holos["rf_crank_s"])
            end)
        
        --Right Rear Single Crank Visuals
        Holos["rr_crank_s_v"] = holograms.create( Holos["rr_crank_s"]:localToWorld( Vector(0, -0.5, 0) ), Holos["rr_crank_s"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_4/cylinder_9x3.mdl", Vector(1, 1, 1) )
            local lbar = holograms.create( Holos["rr_crank_s"]:localToWorld( Vector(8.5, -1.5, -2.3) ), Holos["rr_crank_s"]:localToWorldAngles( Angle(24.5, -12, 90) ), "models/sprops/rectangles_thin/size_1/rect_3x18x1_5.mdl", Vector(0.7, 1.2, 1.2) )
            local hbar1 = holograms.create( Holos["rr_crank_s"]:localToWorld( Vector(0, -0.5, 5.45) ), Holos["rr_crank_s"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/rectangles/size_1_5/rect_6x6x3.mdl", Vector(0.75, 0.542, 0.5) )
            local hbar2 = holograms.create( Holos["rr_crank_s"]:localToWorld( Vector(0, -0.5, 8.2) ), Holos["rr_crank_s"]:localToWorldAngles( Angle(0, 0, 0) ), "models/sprops/geometry/hdisc_12.mdl", Vector(0.375, 0.5, 0.375) )
            Holos["rr_crank_s_lbar2"] = holograms.create( Wheels[12]:localToWorld( Vector(0, -5, 0) ), Baseplate:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/cylinders/size_3/cylinder_6x6.mdl", Vector(1, 1, 1) )
            Holos["rr_crank_s_v"]:setMaterial(mat)
            lbar:setMaterial(mat)
            hbar1:setMaterial(mat)
            hbar2:setMaterial(mat)
            Holos["rr_crank_s_lbar2"]:setMaterial(mat)
            Holos["rr_crank_s_v"]:setColor(col)
            lbar:setColor(col)
            hbar1:setColor(col)
            hbar2:setColor(col)
            Holos["rr_crank_s_lbar2"]:setColor(col)
            Holos["rr_crank_s_v"]:setParent(Holos["rr_crank_s"])
            lbar:setParent(Holos["rr_crank_s"])
            hbar1:setParent(Holos["rr_crank_s"])
            hbar2:setParent(Holos["rr_crank_s"])
            timer.simple(game.getTickInterval()*4, function()
                Holos["rr_crank_s_lbar2"]:setParent(Holos["rr_crank_s"])
            end)
            
        --Springs
        --Left Front Spring for single crank
        Holos["lf_spring_s1"] = holograms.create( Holos["lf_anchor"]:localToWorld( Vector(-28, 0, 0) ), Holos["lf_anchor"]:localToWorldAngles( Angle(90, 0, 0) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        Holos["lf_spring_s2"] = holograms.create( Holos["lf_anchor"]:localToWorld( Vector(-28, 0, 0) ), Holos["lf_anchor"]:localToWorldAngles( Angle(-90, 0, 180) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        local lf_s_bar = holograms.create( Holos["lf_anchor"]:localToWorld( Vector(-28, 0, 0) ), Holos["lf_anchor"]:localToWorldAngles( Angle(0, 90, 0) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        Holos["lf_spring_s1"]:setParent( Holos["lf_anchor"] )
        Holos["lf_spring_s2"]:setParent( Holos["lf_anchor"] )
        lf_s_bar:setColor(col)
        lf_s_bar:setMaterial(mat)
        lf_s_bar:setParent( Holos["lf_anchor"] )
        Holos["lf_s_bar1"] = holograms.create( Holos["lf_anchor"]:localToWorld( Vector(-2.5, 0, 0.8) ), Holos["lf_anchor"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["lf_s_bar1"]:setSize( Vector(0.5, 0.5, 25.5) )
        Holos["lf_s_bar1"]:setParent( Holos["lf_anchor"] )
        Holos["lf_s_bar2"] = holograms.create( Holos["lf_anchor"]:localToWorld( Vector(-2.5, 0, -0.8) ), Holos["lf_anchor"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["lf_s_bar2"]:setSize( Vector(0.5, 0.5, 25.5) )
        Holos["lf_s_bar2"]:setParent( Holos["lf_anchor"] )
        Holos["lf_s_coupling1"] = holograms.create( Holos["lf_crank_s"]:localToWorld( Vector(0, 0.5, 7.5) ), Angle(0), cube, scale )
        local lr_c1_v = holograms.create( Holos["lf_s_coupling1"]:localToWorld( Vector(-2, 0, 0) ), Holos["lf_s_coupling1"]:localToWorldAngles( Angle(0, -90, 0) ), "models/Mechanics/robotics/g1.mdl", Vector(0.05, 0.25, 0.25) )
        local lr_c2_v = holograms.create( Holos["lf_s_coupling1"]:localToWorld( Vector(0) ), Holos["lf_s_coupling1"]:localToWorldAngles( Angle(0 , -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        lr_c1_v:setColor(col)
        lr_c2_v:setColor(col)
        lr_c1_v:setMaterial(mat)
        lr_c2_v:setMaterial(mat)
        lr_c1_v:setParent(Holos["lf_s_coupling1"])
        lr_c2_v:setParent(Holos["lf_s_coupling1"])
        Holos["lf_s_coupling1"]:setParent(Holos["lf_crank_s"])
        Holos["lf_s_bar3"] = holograms.create( Holos["lf_s_coupling1"]:localToWorld( Vector(-3, 0, 0) ), Holos["lf_s_coupling1"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["lf_s_bar3"]:setSize( Vector(0.5, 0.5, 26) )
        Holos["lf_s_bar3"]:setParent( Holos["lf_s_coupling1"] )
        local a2 = holograms.create( Holos["lf_s_coupling1"]:localToWorld( Vector(-29, 0, 0) ), Holos["lf_s_coupling1"]:localToWorldAngles( Angle(0, 90, 0) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        a2:setColor(col)
        a2:setMaterial(mat)
        a2:setParent( Holos["lf_s_coupling1"] )
        local coupling2 = holograms.create( Holos["lf_anchor"]:localToWorld( Vector(0, 0, 0) ), Holos["lf_anchor"]:getAngles(), cube, scale )
        local lr_c1_v = holograms.create( coupling2:localToWorld( Vector(-1.5, 0, 0) ), coupling2:localToWorldAngles( Angle(0, -90, 0) ), "models/Mechanics/robotics/g1.mdl", Vector(0.05, 0.15, 0.2) )
        local lr_c2_v = holograms.create( coupling2:localToWorld( Vector(0) ), coupling2:localToWorldAngles( Angle(0 , -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        lr_c1_v:setColor(col)
        lr_c2_v:setColor(col)
        lr_c1_v:setMaterial(mat)
        lr_c2_v:setMaterial(mat)
        lr_c1_v:setParent(coupling2)
        lr_c2_v:setParent(coupling2)
        coupling2:setParent(Holos["lf_anchor"])
        
        --Left Rear Spring for single crank
        Holos["lr_spring_s1"] = holograms.create( Holos["lr_anchor"]:localToWorld( Vector(-25, 0, 0) ), Holos["lr_anchor"]:localToWorldAngles( Angle(90, 0, 0) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        Holos["lr_spring_s2"] = holograms.create( Holos["lr_anchor"]:localToWorld( Vector(-25, 0, 0) ), Holos["lr_anchor"]:localToWorldAngles( Angle(-90, 0, 180) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        local lr_s_bar = holograms.create( Holos["lr_anchor"]:localToWorld( Vector(-25, 0, 0) ), Holos["lr_anchor"]:localToWorldAngles( Angle(0, 90, 0) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        Holos["lr_spring_s1"]:setParent( Holos["lr_anchor"] )
        Holos["lr_spring_s2"]:setParent( Holos["lr_anchor"] )
        lr_s_bar:setColor(col)
        lr_s_bar:setMaterial(mat)
        lr_s_bar:setParent( Holos["lr_anchor"] )
        Holos["lr_s_bar1"] = holograms.create( Holos["lr_anchor"]:localToWorld( Vector(-2.5, 0, 0.8) ), Holos["lr_anchor"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["lr_s_bar1"]:setSize( Vector(0.5, 0.5, 22.5) )
        Holos["lr_s_bar1"]:setParent( Holos["lr_anchor"] )
        Holos["lr_s_bar2"] = holograms.create( Holos["lr_anchor"]:localToWorld( Vector(-2.5, 0, -0.8) ), Holos["lr_anchor"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["lr_s_bar2"]:setSize( Vector(0.5, 0.5, 22.5) )
        Holos["lr_s_bar2"]:setParent( Holos["lr_anchor"] )
        Holos["lr_s_coupling1"] = holograms.create( Holos["lr_crank_s"]:localToWorld( Vector(0, 0.5, 7.5) ), Angle(0), cube, scale )
        local lr_c1_v = holograms.create( Holos["lr_s_coupling1"]:localToWorld( Vector(-2, 0, 0) ), Holos["lr_s_coupling1"]:localToWorldAngles( Angle(0, -90, 0) ), "models/Mechanics/robotics/g1.mdl", Vector(0.05, 0.25, 0.25) )
        local lr_c2_v = holograms.create( Holos["lr_s_coupling1"]:localToWorld( Vector(0) ), Holos["lr_s_coupling1"]:localToWorldAngles( Angle(0 , -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        lr_c1_v:setColor(col)
        lr_c2_v:setColor(col)
        lr_c1_v:setMaterial(mat)
        lr_c2_v:setMaterial(mat)
        lr_c1_v:setParent(Holos["lr_s_coupling1"])
        lr_c2_v:setParent(Holos["lr_s_coupling1"])
        Holos["lr_s_coupling1"]:setParent(Holos["lr_crank_s"])
        Holos["lr_s_bar3"] = holograms.create( Holos["lr_s_coupling1"]:localToWorld( Vector(-3, 0, 0) ), Holos["lr_s_coupling1"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["lr_s_bar3"]:setSize( Vector(0.5, 0.5, 23.5) )
        Holos["lr_s_bar3"]:setParent( Holos["lr_s_coupling1"] )
        local a2 = holograms.create( Holos["lr_s_coupling1"]:localToWorld( Vector(-26.5, 0, 0) ), Holos["lr_s_coupling1"]:localToWorldAngles( Angle(0, 90, 0) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        a2:setColor(col)
        a2:setMaterial(mat)
        a2:setParent( Holos["lr_s_coupling1"] )
        local coupling2 = holograms.create( Holos["lr_anchor"]:localToWorld( Vector(0, 0, 0) ), Holos["lr_anchor"]:getAngles(), cube, scale )
        local lr_c1_v = holograms.create( coupling2:localToWorld( Vector(-1.5, 0, 0) ), coupling2:localToWorldAngles( Angle(0, -90, 0) ), "models/Mechanics/robotics/g1.mdl", Vector(0.05, 0.15, 0.2) )
        local lr_c2_v = holograms.create( coupling2:localToWorld( Vector(0) ), coupling2:localToWorldAngles( Angle(0 , -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        lr_c1_v:setColor(col)
        lr_c2_v:setColor(col)
        lr_c1_v:setMaterial(mat)
        lr_c2_v:setMaterial(mat)
        lr_c1_v:setParent(coupling2)
        lr_c2_v:setParent(coupling2)
        coupling2:setParent(Holos["lr_anchor"])
        
        --Right Front Spring for single crank
        Holos["rf_spring_s1"] = holograms.create( Holos["rf_anchor"]:localToWorld( Vector(-28, 0, 0) ), Holos["rf_anchor"]:localToWorldAngles( Angle(90, 0, 0) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        Holos["rf_spring_s2"] = holograms.create( Holos["rf_anchor"]:localToWorld( Vector(-28, 0, 0) ), Holos["rf_anchor"]:localToWorldAngles( Angle(-90, 0, 180) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        local rf_s_bar = holograms.create( Holos["rf_anchor"]:localToWorld( Vector(-28, 0, 0) ), Holos["rf_anchor"]:localToWorldAngles( Angle(0, 90, 0) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        Holos["rf_spring_s1"]:setParent( Holos["rf_anchor"] )
        Holos["rf_spring_s2"]:setParent( Holos["rf_anchor"] )
        rf_s_bar:setColor(col)
        rf_s_bar:setMaterial(mat)
        rf_s_bar:setParent( Holos["rf_anchor"] )
        Holos["rf_s_bar1"] = holograms.create( Holos["rf_anchor"]:localToWorld( Vector(-2.5, 0, 0.8) ), Holos["rf_anchor"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["rf_s_bar1"]:setSize( Vector(0.5, 0.5, 25.5) )
        Holos["rf_s_bar1"]:setParent( Holos["rf_anchor"] )
        Holos["rf_s_bar2"] = holograms.create( Holos["rf_anchor"]:localToWorld( Vector(-2.5, 0, -0.8) ), Holos["rf_anchor"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["rf_s_bar2"]:setSize( Vector(0.5, 0.5, 25.5) )
        Holos["rf_s_bar2"]:setParent( Holos["rf_anchor"] )
        Holos["rf_s_coupling1"] = holograms.create( Holos["rf_crank_s"]:localToWorld( Vector(0, 0.5, 7.5) ), Angle(0), cube, scale )
        local lr_c1_v = holograms.create( Holos["rf_s_coupling1"]:localToWorld( Vector(-2, 0, 0) ), Holos["rf_s_coupling1"]:localToWorldAngles( Angle(0, -90, 0) ), "models/Mechanics/robotics/g1.mdl", Vector(0.05, 0.25, 0.25) )
        local lr_c2_v = holograms.create( Holos["rf_s_coupling1"]:localToWorld( Vector(0) ), Holos["rf_s_coupling1"]:localToWorldAngles( Angle(0 , -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        lr_c1_v:setColor(col)
        lr_c2_v:setColor(col)
        lr_c1_v:setMaterial(mat)
        lr_c2_v:setMaterial(mat)
        lr_c1_v:setParent(Holos["rf_s_coupling1"])
        lr_c2_v:setParent(Holos["rf_s_coupling1"])
        Holos["rf_s_coupling1"]:setParent(Holos["rf_crank_s"])
        Holos["rf_s_bar3"] = holograms.create( Holos["rf_s_coupling1"]:localToWorld( Vector(-3, 0, 0) ), Holos["rf_s_coupling1"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["rf_s_bar3"]:setSize( Vector(0.5, 0.5, 26) )
        Holos["rf_s_bar3"]:setParent( Holos["rf_s_coupling1"] )
        local a2 = holograms.create( Holos["rf_s_coupling1"]:localToWorld( Vector(-29, 0, 0) ), Holos["rf_s_coupling1"]:localToWorldAngles( Angle(0, 90, 0) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        a2:setColor(col)
        a2:setMaterial(mat)
        a2:setParent( Holos["rf_s_coupling1"] )
        local coupling2 = holograms.create( Holos["rf_anchor"]:localToWorld( Vector(0, 0, 0) ), Holos["rf_anchor"]:getAngles(), cube, scale )
        local lr_c1_v = holograms.create( coupling2:localToWorld( Vector(-1.5, 0, 0) ), coupling2:localToWorldAngles( Angle(0, -90, 0) ), "models/Mechanics/robotics/g1.mdl", Vector(0.05, 0.15, 0.2) )
        local lr_c2_v = holograms.create( coupling2:localToWorld( Vector(0) ), coupling2:localToWorldAngles( Angle(0 , -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        lr_c1_v:setColor(col)
        lr_c2_v:setColor(col)
        lr_c1_v:setMaterial(mat)
        lr_c2_v:setMaterial(mat)
        lr_c1_v:setParent(coupling2)
        lr_c2_v:setParent(coupling2)
        coupling2:setParent(Holos["rf_anchor"])
        
        --Right Rear Spring for single crank
        Holos["rr_spring_s1"] = holograms.create( Holos["rr_anchor"]:localToWorld( Vector(-25, 0, 0) ), Holos["rr_anchor"]:localToWorldAngles( Angle(90, 0, 0) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        Holos["rr_spring_s2"] = holograms.create( Holos["rr_anchor"]:localToWorld( Vector(-25, 0, 0) ), Holos["rr_anchor"]:localToWorldAngles( Angle(-90, 0, 180) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        local rr_s_bar = holograms.create( Holos["rr_anchor"]:localToWorld( Vector(-25, 0, 0) ), Holos["rr_anchor"]:localToWorldAngles( Angle(0, 90, 0) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        Holos["rr_spring_s1"]:setParent( Holos["rr_anchor"] )
        Holos["rr_spring_s2"]:setParent( Holos["rr_anchor"] )
        rr_s_bar:setColor(col)
        rr_s_bar:setMaterial(mat)
        rr_s_bar:setParent( Holos["rr_anchor"] )
        Holos["rr_s_bar1"] = holograms.create( Holos["rr_anchor"]:localToWorld( Vector(-2.5, 0, 0.8) ), Holos["rr_anchor"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["rr_s_bar1"]:setSize( Vector(0.5, 0.5, 22.5) )
        Holos["rr_s_bar1"]:setParent( Holos["rr_anchor"] )
        Holos["rr_s_bar2"] = holograms.create( Holos["rr_anchor"]:localToWorld( Vector(-2.5, 0, -0.8) ), Holos["rr_anchor"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["rr_s_bar2"]:setSize( Vector(0.5, 0.5, 22.5) )
        Holos["rr_s_bar2"]:setParent( Holos["rr_anchor"] )
        Holos["rr_s_coupling1"] = holograms.create( Holos["rr_crank_s"]:localToWorld( Vector(0, 0.5, 7.5) ), Angle(0), cube, scale )
        local rr_c1_v = holograms.create( Holos["rr_s_coupling1"]:localToWorld( Vector(-2, 0, 0) ), Holos["rr_s_coupling1"]:localToWorldAngles( Angle(0, -90, 0) ), "models/Mechanics/robotics/g1.mdl", Vector(0.05, 0.25, 0.25) )
        local rr_c2_v = holograms.create( Holos["rr_s_coupling1"]:localToWorld( Vector(0) ), Holos["rr_s_coupling1"]:localToWorldAngles( Angle(0 , -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        rr_c1_v:setColor(col)
        rr_c2_v:setColor(col)
        rr_c1_v:setMaterial(mat)
        rr_c2_v:setMaterial(mat)
        rr_c1_v:setParent(Holos["rr_s_coupling1"])
        rr_c2_v:setParent(Holos["rr_s_coupling1"])
        Holos["rr_s_coupling1"]:setParent(Holos["rr_crank_s"])
        Holos["rr_s_bar3"] = holograms.create( Holos["rr_s_coupling1"]:localToWorld( Vector(-3, 0, 0) ), Holos["rr_s_coupling1"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["rr_s_bar3"]:setSize( Vector(0.5, 0.5, 23.5) )
        Holos["rr_s_bar3"]:setParent( Holos["rr_s_coupling1"] )
        local a2 = holograms.create( Holos["rr_s_coupling1"]:localToWorld( Vector(-26.5, 0, 0) ), Holos["rr_s_coupling1"]:localToWorldAngles( Angle(0, 90, 0) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        a2:setColor(col)
        a2:setMaterial(mat)
        a2:setParent( Holos["rr_s_coupling1"] )
        local coupling2 = holograms.create( Holos["rr_anchor"]:localToWorld( Vector(0, 0, 0) ), Holos["rr_anchor"]:getAngles(), cube, scale )
        local rr_c1_v = holograms.create( coupling2:localToWorld( Vector(-1.5, 0, 0) ), coupling2:localToWorldAngles( Angle(0, -90, 0) ), "models/Mechanics/robotics/g1.mdl", Vector(0.05, 0.15, 0.2) )
        local rr_c2_v = holograms.create( coupling2:localToWorld( Vector(0) ), coupling2:localToWorldAngles( Angle(0 , -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        rr_c1_v:setColor(col)
        rr_c2_v:setColor(col)
        rr_c1_v:setMaterial(mat)
        rr_c2_v:setMaterial(mat)
        rr_c1_v:setParent(coupling2)
        rr_c2_v:setParent(coupling2)
        coupling2:setParent(Holos["rr_anchor"])
        
        --Left Side Middle Springs
        Holos["lf_spring1"] = holograms.create( Holos["l_anchor"]:localToWorld( Vector(-0.75, 0, 0) ), Holos["l_anchor"]:localToWorldAngles( Angle(270, 0, 0) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        Holos["lf_spring2"] = holograms.create( Holos["l_anchor"]:localToWorld( Vector(-0.75, 0, 0) ), Holos["l_anchor"]:localToWorldAngles( Angle(90, 0, 180) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        Holos["lr_spring1"] = holograms.create( Holos["l_anchor"]:localToWorld( Vector(0.75, 0, 0) ), Holos["l_anchor"]:localToWorldAngles( Angle(90, 0, 0) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        Holos["lr_spring2"] = holograms.create( Holos["l_anchor"]:localToWorld( Vector(0.75, 0, 0) ), Holos["l_anchor"]:localToWorldAngles( Angle(-90, 0, 180) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        local la_d = holograms.create( Holos["l_anchor"]:localToWorld( Vector(0) ), Holos["l_anchor"]:localToWorldAngles( Angle(0, 90, 0) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 0.75, 0.4) )
        Holos["lr_bar1"] = holograms.create( Holos["l_anchor"]:localToWorld( Vector(0) ), Holos["l_anchor"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["lr_bar1"]:setSize( Vector(0.5, 0.5, 60) )
        Holos["lr_bar2"] = holograms.create( Holos["lr_bar1"]:localToWorld( Vector(0) ), Holos["lr_bar1"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        Holos["lr_coupling1"] = holograms.create( Holos["lr_crank"]:localToWorld( Vector(0, 0.5, 7.5) ), Angle(0), cube, scale )
        local lr_c1_v = holograms.create( Holos["lr_coupling1"]:localToWorld( Vector(0) ), Holos["lr_coupling1"]:localToWorldAngles( Angle(0, -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.2, 0.14, 0.14) )
        local l1 = holograms.create( lr_c1_v:localToWorld( Vector(1.5, -2.5, 0) ), lr_c1_v:localToWorldAngles( Angle(0, 90, 0) ), "models/Mechanics/robotics/h1.mdl", Vector(0.16, 0.1, 0.2) )
        local l2 = holograms.create( lr_c1_v:localToWorld( Vector(-1.5, -2.5, 0) ), lr_c1_v:localToWorldAngles( Angle(0, -90, 180) ), "models/Mechanics/robotics/h1.mdl", Vector(0.16, 0.1, 0.2) )
        local l3 = holograms.create( lr_c1_v:localToWorld( Vector(0, -5.2, 0) ), lr_c1_v:getAngles(), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        lr_c1_v:setColor(col)
        l1:setColor(col)
        l2:setColor(col)
        l3:setColor(col)
        lr_c1_v:setMaterial(mat)
        l1:setMaterial(mat)
        l2:setMaterial(mat)
        l3:setMaterial(mat)
        lr_c1_v:setParent(Holos["lr_coupling1"])
        l1:setParent(Holos["lr_coupling1"])
        l2:setParent(Holos["lr_coupling1"])
        l3:setParent(Holos["lr_coupling1"])
        Holos["lr_coupling1"]:setParent(Holos["lr_crank"])
        
        Holos["lf_bar1"] = holograms.create( Holos["l_anchor"]:localToWorld( Vector(0, 0, -0.8) ), Holos["l_anchor"]:localToWorldAngles( Angle(90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["lf_bar1"]:setSize( Vector(0.5, 0.5, 60) )
        Holos["lf_bar2"] = holograms.create( Holos["l_anchor"]:localToWorld( Vector(0, 0, 0.8) ), Holos["l_anchor"]:localToWorldAngles( Angle(90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["lf_bar2"]:setSize( Vector(0.5, 0.5, 60) )
        Holos["lf_bar3"] = holograms.create( Holos["lf_bar1"]:localToWorld( Vector(0.8, 0, 0) ), Holos["lf_bar1"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        Holos["lf_coupling1"] = holograms.create( Holos["lf_crank"]:localToWorld( Vector(0, 0.5, 7.5) ), Angle(0), cube, scale )
        local lr_c1_v = holograms.create( Holos["lf_coupling1"]:localToWorld( Vector(0) ), Holos["lf_coupling1"]:localToWorldAngles( Angle(0 , -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.2, 0.14, 0.14) )
        local l1 = holograms.create( lr_c1_v:localToWorld( Vector(1.5, -2.5, 0) ), lr_c1_v:localToWorldAngles( Angle(0, 90, 0) ), "models/Mechanics/robotics/h1.mdl", Vector(0.16, 0.1, 0.2) )
        local l2 = holograms.create( lr_c1_v:localToWorld( Vector(-1.5, -2.5, 0) ), lr_c1_v:localToWorldAngles( Angle(0, -90, 180) ), "models/Mechanics/robotics/h1.mdl", Vector(0.16, 0.1, 0.2) )
        local l3 = holograms.create( lr_c1_v:localToWorld( Vector(0, -5.2, 0) ), lr_c1_v:getAngles(), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        local l4 = holograms.create( lr_c1_v:localToWorld( Vector(0, -4.9, 0) ), lr_c1_v:localToWorldAngles( Angle(90, 0, 0) ), "models/Mechanics/robotics/d1.mdl", Vector(0.04, 0.1, 0.1) )
        lr_c1_v:setColor(col)
        l1:setColor(col)
        l2:setColor(col)
        l3:setColor(col)
        l4:setColor(col)
        lr_c1_v:setMaterial(mat)
        l1:setMaterial(mat)
        l2:setMaterial(mat)
        l3:setMaterial(mat)
        l4:setMaterial(mat)
        lr_c1_v:setParent(Holos["lf_coupling1"])
        l1:setParent(Holos["lf_coupling1"])
        l2:setParent(Holos["lf_coupling1"])
        l3:setParent(Holos["lf_coupling1"])
        l4:setParent(Holos["lf_coupling1"])
        Holos["lf_coupling1"]:setParent(Holos["lf_crank"])
        
        la_d:setMaterial(mat)
        la_d:setColor(col)
        Holos["lr_bar2"]:setMaterial(mat)
        Holos["lr_bar2"]:setColor(col)
        Holos["lf_bar3"]:setMaterial(mat)
        Holos["lf_bar3"]:setColor(col)
        Holos["lf_spring1"]:setParent(Holos["l_anchor"])
        Holos["lf_spring2"]:setParent(Holos["l_anchor"])
        Holos["lr_spring1"]:setParent(Holos["l_anchor"])
        Holos["lr_spring2"]:setParent(Holos["l_anchor"])
        Holos["lr_bar1"]:setParent(Holos["l_anchor"])
        Holos["lr_bar2"]:setParent(Holos["lr_bar1"])
        Holos["lf_bar1"]:setParent(Holos["l_anchor"])
        Holos["lf_bar2"]:setParent(Holos["l_anchor"])
        Holos["lf_bar3"]:setParent(Holos["lf_bar1"])
        la_d:setParent(Holos["l_anchor"])
        
        --Right Side Middle Springs
        Holos["rf_spring1"] = holograms.create( Holos["r_anchor"]:localToWorld( Vector(-0.75, 0, 0) ), Holos["r_anchor"]:localToWorldAngles( Angle(270, 0, 0) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        Holos["rf_spring2"] = holograms.create( Holos["r_anchor"]:localToWorld( Vector(-0.75, 0, 0) ), Holos["r_anchor"]:localToWorldAngles( Angle(90, 0, 180) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        Holos["rr_spring1"] = holograms.create( Holos["r_anchor"]:localToWorld( Vector(0.75, 0, 0) ), Holos["r_anchor"]:localToWorldAngles( Angle(90, 0, 0) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        Holos["rr_spring2"] = holograms.create( Holos["r_anchor"]:localToWorld( Vector(0.75, 0, 0) ), Holos["r_anchor"]:localToWorldAngles( Angle(-90, 0, 180) ), "models/sprops/trans/misc/coil.mdl", Vector(0.9, 0.9, 1.75) )
        
        Holos["rf_bar1"] = holograms.create( Holos["r_anchor"]:localToWorld( Vector(0, 0, -0.8) ), Holos["r_anchor"]:localToWorldAngles( Angle(90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["rf_bar1"]:setSize( Vector(0.5, 0.5, 60) )
        Holos["rf_bar2"] = holograms.create( Holos["r_anchor"]:localToWorld( Vector(0, 0, 0.8) ), Holos["r_anchor"]:localToWorldAngles( Angle(90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["rf_bar2"]:setSize( Vector(0.5, 0.5, 60) )
        Holos["rf_bar3"] = holograms.create( Holos["rf_bar1"]:localToWorld( Vector(0.8, 0, 0) ), Holos["rf_bar1"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        Holos["rf_coupling1"] = holograms.create( Holos["rf_crank"]:localToWorld( Vector(0, -0.5, 7.5) ), Angle(0), cube, scale )
        local lr_c1_v = holograms.create( Holos["rf_coupling1"]:localToWorld( Vector(0) ), Holos["rf_coupling1"]:localToWorldAngles( Angle(0 , -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.2, 0.14, 0.14) )
        local l1 = holograms.create( lr_c1_v:localToWorld( Vector(1.5, -2.5, 0) ), lr_c1_v:localToWorldAngles( Angle(0, 90, 0) ), "models/Mechanics/robotics/h1.mdl", Vector(0.16, 0.1, 0.2) )
        local l2 = holograms.create( lr_c1_v:localToWorld( Vector(-1.5, -2.5, 0) ), lr_c1_v:localToWorldAngles( Angle(0, -90, 180) ), "models/Mechanics/robotics/h1.mdl", Vector(0.16, 0.1, 0.2) )
        local l3 = holograms.create( lr_c1_v:localToWorld( Vector(0, -5.2, 0) ), lr_c1_v:getAngles(), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        local l4 = holograms.create( lr_c1_v:localToWorld( Vector(0, -4.9, 0) ), lr_c1_v:localToWorldAngles( Angle(90, 0, 0) ), "models/Mechanics/robotics/d1.mdl", Vector(0.04, 0.1, 0.1) )
        lr_c1_v:setColor(col)
        l1:setColor(col)
        l2:setColor(col)
        l3:setColor(col)
        l4:setColor(col)
        lr_c1_v:setMaterial(mat)
        l1:setMaterial(mat)
        l2:setMaterial(mat)
        l3:setMaterial(mat)
        l4:setMaterial(mat)
        lr_c1_v:setParent(Holos["rf_coupling1"])
        l1:setParent(Holos["rf_coupling1"])
        l2:setParent(Holos["rf_coupling1"])
        l3:setParent(Holos["rf_coupling1"])
        l4:setParent(Holos["rf_coupling1"])
        Holos["rf_coupling1"]:setParent(Holos["rf_crank"])
        
        local ra_d = holograms.create( Holos["r_anchor"]:localToWorld( Vector(0) ), Holos["r_anchor"]:localToWorldAngles( Angle(0, 90, 0) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 0.75, 0.4) )
        
        Holos["rr_bar1"] = holograms.create( Holos["r_anchor"]:localToWorld( Vector(0) ), Holos["r_anchor"]:localToWorldAngles( Angle(-90, 0, 0) ), "models/sprops/misc/cube_from_z.mdl", Vector(0.4, 0.4, 0.75) )
        Holos["rr_bar1"]:setSize( Vector(0.5, 0.5, 60) )
        Holos["rr_bar2"] = holograms.create( Holos["rr_bar1"]:localToWorld( Vector(0) ), Holos["rr_bar1"]:localToWorldAngles( Angle(0, 0, 90) ), "models/sprops/geometry/t_fdisc_12.mdl", Vector(0.4, 1.25, 0.4) )
        Holos["rr_coupling1"] = holograms.create( Holos["rr_crank"]:localToWorld( Vector(0, -0.5, 7.5) ), Angle(0), cube, scale )
        local lr_c1_v = holograms.create( Holos["rr_coupling1"]:localToWorld( Vector(0) ), Holos["rr_coupling1"]:localToWorldAngles( Angle(0, -90, 0) ), "models/Mechanics/robotics/a1.mdl", Vector(0.2, 0.14, 0.14) )
        local l1 = holograms.create( lr_c1_v:localToWorld( Vector(1.5, -2.5, 0) ), lr_c1_v:localToWorldAngles( Angle(0, 90, 0) ), "models/Mechanics/robotics/h1.mdl", Vector(0.16, 0.1, 0.2) )
        local l2 = holograms.create( lr_c1_v:localToWorld( Vector(-1.5, -2.5, 0) ), lr_c1_v:localToWorldAngles( Angle(0, -90, 180) ), "models/Mechanics/robotics/h1.mdl", Vector(0.16, 0.1, 0.2) )
        local l3 = holograms.create( lr_c1_v:localToWorld( Vector(0, -5.2, 0) ), lr_c1_v:getAngles(), "models/Mechanics/robotics/a1.mdl", Vector(0.14, 0.14, 0.14) )
        lr_c1_v:setColor(col)
        l1:setColor(col)
        l2:setColor(col)
        l3:setColor(col)
        lr_c1_v:setMaterial(mat)
        l1:setMaterial(mat)
        l2:setMaterial(mat)
        l3:setMaterial(mat)
        lr_c1_v:setParent(Holos["rr_coupling1"])
        l1:setParent(Holos["rr_coupling1"])
        l2:setParent(Holos["rr_coupling1"])
        l3:setParent(Holos["rr_coupling1"])
        Holos["rr_coupling1"]:setParent(Holos["rr_crank"])
        
        ra_d:setMaterial(mat)
        ra_d:setColor(col)
        Holos["rf_spring1"]:setParent(Holos["r_anchor"])
        Holos["rf_spring2"]:setParent(Holos["r_anchor"])
        Holos["rr_spring1"]:setParent(Holos["r_anchor"])
        Holos["rr_spring2"]:setParent(Holos["r_anchor"])
        ra_d:setParent(Holos["r_anchor"])
        
        ra_d:setMaterial(mat)
        ra_d:setColor(col)
        Holos["rr_bar2"]:setMaterial(mat)
        Holos["rr_bar2"]:setColor(col)
        Holos["rf_bar3"]:setMaterial(mat)
        Holos["rf_bar3"]:setColor(col)
        Holos["rf_spring1"]:setParent(Holos["r_anchor"])
        Holos["rf_spring2"]:setParent(Holos["r_anchor"])
        Holos["rr_spring1"]:setParent(Holos["r_anchor"])
        Holos["rr_spring2"]:setParent(Holos["r_anchor"])
        Holos["rr_bar1"]:setParent(Holos["r_anchor"])
        Holos["rr_bar2"]:setParent(Holos["rr_bar1"])
        Holos["rf_bar1"]:setParent(Holos["r_anchor"])
        Holos["rf_bar2"]:setParent(Holos["r_anchor"])
        Holos["rf_bar3"]:setParent(Holos["rf_bar1"])
        ra_d:setParent(Holos["r_anchor"])
        
        
        --Set up the single crank anchors real quick.
        Holos["lf_anchor"]:setParent( Holos["lf_crank_nub"] )
        Holos["lf_anchor"]:setPos( Holos["lf_crank_nub"]:getPos() )
        
        Holos["lr_anchor"]:setParent( Holos["lr_crank_nub"] )
        Holos["lr_anchor"]:setPos( Holos["lr_crank_nub"]:getPos() )
        
        Holos["rf_anchor"]:setParent( Holos["rf_crank_nub"] )
        Holos["rf_anchor"]:setPos( Holos["rf_crank_nub"]:getPos() )
        
        Holos["rr_anchor"]:setParent( Holos["rr_crank_nub"] )
        Holos["rr_anchor"]:setPos( Holos["rr_crank_nub"]:getPos() )
    end
end)

--Handle the animation
local last_s1 = 0
local last_s2 = 0
local last_s3 = 0
local last_s4 = 0
local last_s5 = 0
local last_s6 = 0
local last_s7 = 0
local last_s8 = 0
local skip = false
hook.add("tick", "octoBCSATick", function()
    if Wheels == {} then return end --If there are no wheels then there is no point in running
    
    skip = !skip --Lazy tick skip, runs at half the tick rate of the server (if the tick rate is 33 and not 66, comment out this block.
    if skip then
        return
    end
    
    Holos["lf_bogey"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( (Wheels[2]:getPos()-Wheels[3]:getPos()):getAngle() ) * Angle(1, 0, 0) ) )
    Holos["lr_bogey"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( (Wheels[4]:getPos()-Wheels[5]:getPos()):getAngle() ) * Angle(1, 0, 0) ) )
    Holos["lf_bogey"]:setPos( (Wheels[2]:getPos()+Wheels[3]:getPos())/2 + (Holos["lf_bogey"]:getUp() * Vector(3.5)) )-- + 5 + math.sin(timer.curtime()*6)*5)) )
    Holos["lr_bogey"]:setPos( (Wheels[4]:getPos()+Wheels[5]:getPos())/2 + (Holos["lr_bogey"]:getUp() * Vector(3.5)) )-- + 5 + math.sin(timer.curtime()*6)*5)) )
    
    Holos["rf_bogey"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( (Wheels[8]:getPos()-Wheels[9]:getPos()):getAngle() ) * Angle(1, 0, 0) ) )
    Holos["rr_bogey"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( (Wheels[10]:getPos()-Wheels[11]:getPos()):getAngle() ) * Angle(1, 0, 0) ) )
    Holos["rf_bogey"]:setPos( (Wheels[8]:getPos()+Wheels[9]:getPos())/2 + (Holos["rf_bogey"]:getUp() * Vector(3.5)) )
    Holos["rr_bogey"]:setPos( (Wheels[10]:getPos()+Wheels[11]:getPos())/2 + (Holos["rr_bogey"]:getUp() * Vector(3.5)) )
    
    Holos["lf_crank"]:setAngles( Baseplate:localToWorldAngles( Angle( 108+math.deg(math.atan2( Baseplate:worldToLocal(Holos["lf_bogey"]:getPos())[1]-Baseplate:worldToLocal(Holos["lf_crank"]:getPos())[1], Baseplate:worldToLocal(Holos["lf_bogey"]:getPos())[3]-Baseplate:worldToLocal(Holos["lf_crank"]:getPos())[3] )), 0, 0) ) )
    Holos["rf_crank"]:setAngles( Baseplate:localToWorldAngles( Angle( 108+math.deg(math.atan2( Baseplate:worldToLocal(Holos["rf_bogey"]:getPos())[1]-Baseplate:worldToLocal(Holos["rf_crank"]:getPos())[1], Baseplate:worldToLocal(Holos["rf_bogey"]:getPos())[3]-Baseplate:worldToLocal(Holos["rf_crank"]:getPos())[3] )), 0, 0) ) )
    Holos["lr_crank"]:setAngles(  Baseplate:localToWorldAngles( Angle( -108+math.deg(math.atan2( Baseplate:worldToLocal(Holos["lr_bogey"]:getPos())[1]-Baseplate:worldToLocal(Holos["lr_crank"]:getPos())[1], Baseplate:worldToLocal(Holos["lr_bogey"]:getPos())[3]-Baseplate:worldToLocal(Holos["lr_crank"]:getPos())[3] )), 0, 0) ) )
    Holos["rr_crank"]:setAngles(  Baseplate:localToWorldAngles( Angle( -108+math.deg(math.atan2( Baseplate:worldToLocal(Holos["rr_bogey"]:getPos())[1]-Baseplate:worldToLocal(Holos["rr_crank"]:getPos())[1], Baseplate:worldToLocal(Holos["rr_bogey"]:getPos())[3]-Baseplate:worldToLocal(Holos["rr_crank"]:getPos())[3] )), 0, 0) ) )
    
    Holos["lf_crank_s"]:setAngles( Baseplate:localToWorldAngles( Angle( 108+math.deg(math.atan2( Baseplate:worldToLocal(Wheels[1]:getPos())[1]-Baseplate:worldToLocal(Holos["lf_crank_s"]:getPos())[1], Baseplate:worldToLocal(Wheels[1]:getPos())[3]-Baseplate:worldToLocal(Holos["lf_crank"]:getPos())[3] )), 0, 0) ) )
    Holos["lr_crank_s"]:setAngles( Baseplate:localToWorldAngles( Angle( -108+math.deg(math.atan2( Baseplate:worldToLocal(Wheels[6]:getPos())[1]-Baseplate:worldToLocal(Holos["lr_crank_s"]:getPos())[1], Baseplate:worldToLocal(Wheels[6]:getPos())[3]-Baseplate:worldToLocal(Holos["lr_crank"]:getPos())[3] )), 0, 0) ) )
    Holos["rf_crank_s"]:setAngles( Baseplate:localToWorldAngles( Angle( 108+math.deg(math.atan2( Baseplate:worldToLocal(Wheels[7]:getPos())[1]-Baseplate:worldToLocal(Holos["rf_crank_s"]:getPos())[1], Baseplate:worldToLocal(Wheels[7]:getPos())[3]-Baseplate:worldToLocal(Holos["rf_crank"]:getPos())[3] )), 0, 0) ) )
    Holos["rr_crank_s"]:setAngles( Baseplate:localToWorldAngles( Angle( -108+math.deg(math.atan2( Baseplate:worldToLocal(Wheels[12]:getPos())[1]-Baseplate:worldToLocal(Holos["rr_crank_s"]:getPos())[1], Baseplate:worldToLocal(Wheels[12]:getPos())[3]-Baseplate:worldToLocal(Holos["rr_crank"]:getPos())[3] )), 0, 0) ) )
    
    --Left side springs
    local s1 = (Holos["lr_spring1"]:getPos():getDistance( Holos["lr_crank"]:localToWorld(Vector(0,0,8.2)) ) - 43.347956058704)
    Holos["lr_bar1"]:setPos( Holos["lr_spring1"]:localToWorld( Vector(0, 0, 22 - s1) ) )
    Holos["lr_spring1"]:setSize( Vector(6.2, 6.2, (22-last_s1)*4.07825 ) )
    Holos["lr_spring2"]:setSize( Vector(6.2, 6.2, (22-last_s1)*4.07825 ) )
    
    local s2 = (Holos["lf_spring1"]:getPos():getDistance( Holos["lf_crank"]:localToWorld(Vector(0,0,8.2)) ) - 43.347956058704)
    Holos["lf_bar1"]:setPos( Holos["lf_spring1"]:localToWorld( Vector(0.8, 0, 22 - s2) ) )
    Holos["lf_bar2"]:setPos( Holos["lf_spring1"]:localToWorld( Vector(-0.8, 0, 22 - s2) ) )
    Holos["lf_spring1"]:setSize( Vector(6.2, 6.2, (22-last_s2)*4.07825 ) )
    Holos["lf_spring2"]:setSize( Vector(6.2, 6.2, (22-last_s2)*4.07825 ) )
    
    --Right side sprigns
    local s3 = (Holos["rr_spring1"]:getPos():getDistance( Holos["rr_crank"]:localToWorld(Vector(0,0,8.2)) ) - 43.347956058704)
    Holos["rr_bar1"]:setPos( Holos["rr_spring1"]:localToWorld( Vector(0, 0, 22 - s3) ) )
    Holos["rr_spring1"]:setSize( Vector(6.2, 6.2, (22-last_s3)*4.07825 ) )
    Holos["rr_spring2"]:setSize( Vector(6.2, 6.2, (22-last_s3)*4.07825 ) )
    
    local s4 = (Holos["rf_spring1"]:getPos():getDistance( Holos["rf_crank"]:localToWorld(Vector(0,0,8.2)) ) - 43.347956058704)
    Holos["rf_bar1"]:setPos( Holos["rf_spring1"]:localToWorld( Vector(0.8, 0, 22 - s4) ) )
    Holos["rf_bar2"]:setPos( Holos["rf_spring1"]:localToWorld( Vector(-0.8, 0, 22 - s4) ) )
    Holos["rf_spring1"]:setSize( Vector(6.2, 6.2, (22-last_s4)*4.07825 ) )
    Holos["rf_spring2"]:setSize( Vector(6.2, 6.2, (22-last_s4)*4.07825 ) )
    
    --Left Front Spring
    local s5 = (Holos["lf_crank_nub"]:getPos():getDistance( Holos["lf_crank_s"]:localToWorld(Vector(0,0,8.2)) ) - 36.818155130646)
    Holos["lf_spring_s1"]:setSize( Vector(6.2, 6.2, (20-last_s5)*4.07825 ) )
    Holos["lf_spring_s2"]:setSize( Vector(6.2, 6.2, (20-last_s5)*4.07825 ) )
    
    --Left Rear Spring
    local s6 = (Holos["lr_crank_nub"]:getPos():getDistance( Holos["lr_crank_s"]:localToWorld(Vector(0,0,8.2)) ) - 36.818155130646)
    Holos["lr_spring_s1"]:setSize( Vector(6.2, 6.2, (14-last_s6)*4.07825 ) )
    Holos["lr_spring_s2"]:setSize( Vector(6.2, 6.2, (14-last_s6)*4.07825 ) )
    
    --Right Front Spring
    local s7 = (Holos["rf_crank_nub"]:getPos():getDistance( Holos["rf_crank_s"]:localToWorld(Vector(0,0,8.2)) ) - 36.818155130646)
    Holos["rf_spring_s1"]:setSize( Vector(6.2, 6.2, (20-last_s7)*4.07825 ) )
    Holos["rf_spring_s2"]:setSize( Vector(6.2, 6.2, (20-last_s7)*4.07825 ) )
    
    --Right Rear Spring
    local s8 = (Holos["rr_crank_nub"]:getPos():getDistance( Holos["rr_crank_s"]:localToWorld(Vector(0,0,8.2)) ) - 36.818155130646)
    Holos["rr_spring_s1"]:setSize( Vector(6.2, 6.2, (14-last_s8)*4.07825 ) )
    Holos["rr_spring_s2"]:setSize( Vector(6.2, 6.2, (14-last_s8)*4.07825 ) )
    
    timer.simple(game.getTickInterval()*7, function()
        last_s1 = s1
        last_s2 = s2
        last_s3 = s3
        last_s4 = s4
        last_s5 = s5
        last_s6 = s6
        last_s7 = s7
        last_s8 = s8
    end)

    --Makes the single cranks point at the right things.
    Holos["lf_anchor"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["lf_anchor"]:getPos() - Holos["lf_s_coupling1"]:getPos() ):getAngle() ) * Angle(1, 1, 0) ) )
    Holos["lf_s_coupling1"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["lf_s_coupling1"]:getPos() - Holos["lf_anchor"]:getPos() ):getAngle() ) * Angle(1, 1, 0) ) )
    
    Holos["lr_anchor"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["lr_anchor"]:getPos() - Holos["lr_s_coupling1"]:getPos() ):getAngle() ) * Angle(1, 1, 0) ) )
    Holos["lr_s_coupling1"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["lr_s_coupling1"]:getPos() - Holos["lr_anchor"]:getPos() ):getAngle() ) * Angle(1, 1, 0) ) )
    
    Holos["rf_anchor"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["rf_anchor"]:getPos() - Holos["rf_s_coupling1"]:getPos() ):getAngle() ) * Angle(1, 1, 0) ) )
    Holos["rf_s_coupling1"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["rf_s_coupling1"]:getPos() - Holos["rf_anchor"]:getPos() ):getAngle() ) * Angle(1, 1, 0) ) )
    
    Holos["rr_anchor"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["rr_anchor"]:getPos() - Holos["rr_s_coupling1"]:getPos() ):getAngle() ) * Angle(1, 1, 0) ) )
    Holos["rr_s_coupling1"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["rr_s_coupling1"]:getPos() - Holos["rr_anchor"]:getPos() ):getAngle() ) * Angle(1, 1, 0) ) )
    
    --Makes the middle section couplings point correctly
    Holos["lf_coupling1"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["lf_coupling1"]:getPos() - Holos["lf_bar1"]:localToWorld( Vector(0.8, 0, 60) ) ):getAngle() ) * Angle(1, 0, 0) ) )
    Holos["rf_coupling1"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["rf_coupling1"]:getPos() - Holos["rf_bar1"]:localToWorld( Vector(0.8, 0, 60) ) ):getAngle() ) * Angle(1, 0, 0) ) )
    
    Holos["lr_coupling1"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["lr_coupling1"]:getPos() - Holos["lr_bar1"]:localToWorld( Vector(0, 0, 60) ) ):getAngle() ) * Angle(1, 1, 0) ) )
    Holos["rr_coupling1"]:setAngles( Baseplate:localToWorldAngles( Baseplate:worldToLocalAngles( ( Holos["rr_coupling1"]:getPos() - Holos["rr_bar1"]:localToWorld( Vector(0, 0, 60) ) ):getAngle() ) * Angle(1, 1, 0) ) )
end)
