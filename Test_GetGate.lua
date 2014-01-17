--@name Gate Rings
--@author TAJG

local sg = loadLibrary("stargate")
local wire = loadLibrary("wire")
local time = loadLibrary("time")
local ents = loadLibrary("ents")
local holo = loadLibrary("holograms")

wire.createInputs({"Stargate","IrisControl","DialPos","DialAng"},{"wirelink","normal","vector","angle"})
StrGts = sg.getAllStargates()
for i = 1, #StrGts do
    print(string.format("%i: Address: %s, Group: %s, Name: %s, Owner: %s", i, sg.address(StrGts[i]), sg.group(StrGts[i]), sg.name(StrGts[i]), StrGts[i]:owner() ) )    
end
Chip = ents.self()
MrSGE = Chip:isWeldedTo()
--MrSG = wire.ports.Stargate
--MrSGE = MrSG:entity()
MrIris = sg.iris(MrSGE)
--sg.close(MrSGE)
--sg.dial(MrSGE, StrGts[3], 2)
--[[
sg.setAddress(MrSGE, "LAV0PN")
sg.setGroup(MrSGE, "U@#")
sg.setName(MrSGE, "Lava Planet")
]]--


Model = "models/holograms/hq_torus_thin.mdl"
RPos = MrSGE:pos()
RAng = MrSGE:ang()
scale = Vector(4,4,5)
scale2 = Vector(8,8,8)
scale3 = Vector(12,12,12)
scale4 = Vector(16,16,16)
RingColour = {0,255,0,100}
ring = holo.create(RPos, RAng, Model, scale)
ring2 = holo.create(RPos, RAng, Model, scale2)
ring3 = holo.create(RPos, RAng, Model, scale3)
ring4 = holo.create(RPos, RAng, Model, scale4)
IrisRing = holo.create(RPos, RAng, "models/props_c17/streetsign004f.mdl", Vector(5,15,5))
IrisRingo = holo.create(RPos, RAng, "models/holograms/hq_torus_thin.mdl", Vector(18.5,18.5,8))


hook("think","hologramms",function()

if sg.inbound(MrSGE) == true and sg.open(MrSGE) == true then
    RingColour = {255,0,0,100}
    time.stimer(2, function()
        sg.transmit(MrSGE, "TAJG")
    end)
elseif sg.inbound(MrSGE) == false and sg.open(MrSGE) == true then
    RingColour = {0,255,0,100}
elseif sg.open(MrSGE) == false and sg.active(MrSGE) == true then
    RingColour = {0,0,255,100}
else RingColour = {255,255,255,75}
end
if sg.irisActive(MrIris) == true then
    
    IrisRingo:setColor(255,0,0,255)
elseif sg.irisActive(MrIris) == false then
    
    IrisRingo:setColor(0,255,0,255)
end


if MrGE:inbound() == true then
    if ( MrSGE:open() and sg.irisActive( MrIris ) ) == true then
        IrisRing:setAng( wire.ports.DialAng - Angle(0,90,0))
        IrisRing:setColor(255,255,255,255)
        IrisRing:setPos( wire.ports.DialPos )
    elseif MrSGE:open() == true and sg.irisActive( MrIris ) == false then
        IrisRing:setColor(255,0,0,0)
    end
elseif MrSGE:inbound() == false then
    IrisRing:setPos( RPos )
    IrisRing:setColor(255,0,0,0)
end



RPos = MrSGE:pos()
RAng = MrSGE:ang()
NewAng = RAng + Angle(90,0,0)

IrisRingo:setAng(NewAng)

IrisRingo:setPos(RPos)
ring:setColor(unpack(RingColour))
ring2:setColor(unpack(RingColour))
ring3:setColor(unpack(RingColour))
ring4:setColor(unpack(RingColour))
ring:setAng(NewAng)
ring2:setAng(NewAng)
ring3:setAng(NewAng)
ring4:setAng(NewAng)
ring:setPos(RPos)
ring2:setPos(RPos)
ring3:setPos(RPos)
ring4:setPos(RPos)
end)
