--@name Ultimate Control
--@author TAJG

local WireLib = loadLibrary("wire")
local ChatLib = loadLibrary("chat")
local EntityLib = loadLibrary("ents")
local Owner = EntityLib:owner()

WireLib.createInputs({"ResourceCache","LSCore","WaterSplitter","WaterPump"},{"wirelink","wirelink","wirelink","wirelink"})
CA = WireLib.ports.ResourceCache
CR = WireLib.ports.LSCore
WS = WireLib.ports.WaterSplitter
WP = WireLib.ports.WaterPump

-- Modules
LS = false -- LSCore, WaterSplitter, WaterPump operations {REQUIRES RD TO WORK}
RD = false -- Resource stuff, like energy and other resources
SG = false -- Stargate and ring stuff 


function getPercent(Value1, Value2)
	return (Value1 / Value2) * 100
end


function StargateModule()
	do stargate stuff...

end

function LifeSupportModule()
	do life support stuff...

end

function ResourceAmmountGet(resource)
	if resource == "Oxygen" then
		local Value1 = CA.oxygen
		local Value2 = CA.["Max oxygen"]
		return getPercent(Value1, Value2)
	end
	if resource == "Power" then
		local Value1 = CA.energy
		local Value2 = CA.["Max energy"]
		return getPercent(Value1, Value2)
	end
	if resource == "Water" then
		local Value1 = CA.water
		local Value2 = CA.["Max water"]
		return getPercent(Value1, Value2)
	end
end

function RDStatus()
	if O2 > 15 then
		Oxygen = "OK"
	elseif O2 < 15 then
		Oxygen = "BAD"
	end
	if PWR > 15 then
		Power = "OK"
	elseif PWR < 15 then
		Power = "BAD"
	end
	if WTR > 15 then
		Water = "OK"
	elseif WTR < 15 then
		Water = "BAD"
	end
	print(string.format("Oxygen: %s",Oxygen))
	print(string.format("Power: %s",Power))
	print(string.format("Water: %s",Water))
end


-- Loading of moduals for hooking
if LS = true then
	hook("input","LifeSupport", LifeSupportModule() )
end

if RD = true then
	hook("think","ResourceDistribution", function()
		O2 = ResourceAmmountGet("Oxygen")
		PWR = ResourceAmmountGet("Power")
		WTR = ResourceAmmountGet("Water")
		
end 

local function ParseChat( Message, Player )
	Command = Message:sub(1, 5)
	Params = Message:sub(6)
	if Command:lower() == "/resources" then
		RDStatus( Params )
	end
end

ChatLib.listen( ParseChat, Owner )
