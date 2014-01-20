--@name Gate Rings
--@author TAJG
--@sharedscreen

local EntLib = loadLibrary("ents")
local HoloLib = loadLibrary("holograms")
local NetLib = loadLibrary("net")
local Chip = EntLib.self()
local Owner = EntLib.owner()


if SERVER then
local SGLib = loadLibrary("stargate")
local WireLib = loadLibrary("wire")

WireLib.createInputs({"Stargate","IrisControl","DialPos","DialAng","HUD"},{"wirelink","normal","vector","angle","wirelink"})
--[[StrGts = SGLib.getAllStargates()
for i = 1, #StrGts do
    printConsole(string.format("%i: Address: %s, Group: %s, Name: %s, Owner: %s", i, SGLib.address(StrGts[i]), SGLib.group(StrGts[i]), SGLib.name(StrGts[i]), StrGts[i]:owner() ) )    
end
]]--
local MrSGE = Chip:isWeldedTo()
local MrSGW = MrSGE:getWirelink()
--MrSG = WireLib.ports.Stargate
--MrSGE = MrSG:entity()
local MrIris = SGLib.iris(MrSGE)
local t = {}


Model = "models/holograms/hq_torus_thin.mdl"
RPos = MrSGE:pos()
RAng = MrSGE:ang()
scale = Vector(4,4,5)
scale2 = Vector(8,8,8)
scale3 = Vector(12,12,12)
scale4 = Vector(16,16,16)
RingColour = {0,255,0,100}
--ring = HoloLib.create(RPos, RAng, Model, scale)
ring2 = HoloLib.create(RPos, RAng, Model, scale2)
ring3 = HoloLib.create(RPos, RAng, Model, scale3)
--ring4 = HoloLib.create(RPos, RAng, Model, scale4)
IrisRing = HoloLib.create(RPos, RAng, "models/props_c17/streetsign004f.mdl", Vector(5,15,5))
IrisRingo = HoloLib.create(RPos, RAng, "models/holograms/hq_torus_thin.mdl", Vector(18.5,18.5,8))


hook("think","hologramms",function()

    if SGLib.inbound(MrSGE) == true and SGLib.open(MrSGE) == true then
        RingColour = {255,0,0,100}
    elseif SGLib.inbound(MrSGE) == false and SGLib.open(MrSGE) == true then
        RingColour = {0,255,0,100}
    elseif SGLib.open(MrSGE) == false and SGLib.active(MrSGE) == true then
        RingColour = {0,0,255,100}
    else RingColour = {255,255,255,75}
    end
    if SGLib.irisActive(MrIris) == true then
    
        IrisRingo:setColor(255,0,0,255)
    elseif SGLib.irisActive(MrIris) == false then
    
        IrisRingo:setColor(0,255,0,255)
    end


    if MrSGE:inbound() == true then
        if ( MrSGE:open() and SGLib.irisActive( MrIris ) ) == true then
            if MrSGE:target() ~= nil then
                IrisRing:setAng( MrSGE:target():ang() - Angle(0,90,0))
                IrisRing:setColor(255,255,255,255)
                IrisRing:setPos( MrSGE:target():pos() )
            end
        elseif MrSGE:open() == true and SGLib.irisActive( MrIris ) == false then
            IrisRing:setColor(255,0,0,0)
        end
    elseif MrSGE:inbound() == false then
        IrisRing:setPos( RPos )
        IrisRing:setColor(255,0,0,0)
    end
    
    if Chip ~= nil then
        if MrSGE:target() ~= nil then
            t.targAddr = MrSGE:target():address()
            t.targGrup = MrSGE:target():group()
            t.targName = MrSGE:target():name()
        else
            t.targAddr = ""
            t.targName = ""
            t.targGrup = ""
        end
        t.gateAddr = MrSGE:address()
        t.gateName = MrSGE:name()
        t.gateActi = MrSGE:active()
        t.gateOpen = MrSGE:open()
        t.gateInbo = MrSGE:inbound()
        t.gateChev = MrSGW['Dialing Address']
        if SGLib.irisActive(MrIris) then
            t.irisActi = "closed"
        else
            t.irisActi = "open"
        end
        if NetLib.start() then
            NetLib.writeString("HUDInfoSend")
            NetLib.writeTable( t )
            NetLib.broadcast()
        end
    end

    RPos = MrSGE:pos()
    RAng = MrSGE:ang()
    NewAng = RAng + Angle(90,0,0)

    IrisRingo:setAng(NewAng)
    IrisRingo:setPos(RPos)
    --ring:setColor(unpack(RingColour))
    ring2:setColor(unpack(RingColour))
    ring3:setColor(unpack(RingColour))
    --ring4:setColor(unpack(RingColour))
    --ring:setAng(NewAng)
    ring2:setAng(NewAng)
    ring3:setAng(NewAng)
    --ring4:setAng(NewAng)
    --ring:setPos(RPos)
    ring2:setPos(RPos)
    ring3:setPos(RPos)
    --ring4:setPos(RPos)
end)

end ---- END OF SERVER ----

if CLIENT then
    local RenderLib = loadLibrary("render")    
    ScreenX, ScreenY = RenderLib.getScreenRes()
    --ScreenRes = string.format("%i:%i",ScreenX,ScreenY)
    ScreenRes = "1600:900"
    Font = RenderLib.createFont( "Trebuchet", 26, 750, true )
    --Font = RenderLib.createFont( "Anquietas", 26, 750, true )
    Font2 = RenderLib.createFont( "Stargate Address Glyphs SG1", 26, 750, true)
    local Table = {}

    function TenEightyP()
        RenderLib.clear()
        RenderLib.setColor(0,0,0,220)
        RenderLib.drawRect(1500, 100, 400, 800)
    end  
    
    function SixteenByNine()
        BoxX = 1260
        BoxY = 200
        RenderLib.clear()
        RenderLib.setColor(89,89,89,180)
        RenderLib.drawRect(BoxX, BoxY, 340, 600)  
        RenderLib.setColor(255,255,255,255) 
        RenderLib.drawText(Font, BoxX + 5, BoxY + 10, string.format("Address: %s#", Table.gateAddr), RenderLib.ALIGN_TEXT_CENTER )
        RenderLib.drawText(Font2, BoxX + 5, BoxY + 34, string.format("%s#", Table.gateAddr), RenderLib.ALIGN_TEXT_CENTER )
        RenderLib.drawText(Font, BoxX + 5, BoxY + 60, string.format("Name: %s", Table.gateName), RenderLib.ALIGN_TEXT_CENTER )
        if Table.gateActi then
            RenderLib.drawText(Font, BoxX + 5, BoxY + 90, "!TARGET GATE!")
            RenderLib.drawText(Font, BoxX + 5, BoxY + 110, string.format("Address: %s Group: %s", Table.targAddr, Table.targGrup) )
            RenderLib.drawText(Font2, BoxX + 5, BoxY + 130, string.format("%s", Table.gateChev))
        end

        RenderLib.drawText(Font, BoxX + 5, BoxY + 480, string.format("Iris is %s", Table.irisActi))
        RenderLib.drawText(Font, BoxX + 5, BoxY + 500, string.format("P: %s", Owner:ping() ), RenderLib.ALIGN_TEXT_CENTER )
                
    end
    
    function NetStuff()
        if NetLib.readString() == "HUDInfoSend" then
            Table = NetLib.readTable()
        end
    end
    
    
    if ScreenRes == "1920:1080" then
    hook("render", "1920x1080", TenEightyP )
    elseif ScreenRes == "1600:900" then
    hook("render", "1600:900", SixteenByNine )
    end
    hook("net", "networking", NetStuff )
end
