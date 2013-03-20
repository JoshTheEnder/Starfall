--@name Ultimate Control
--@author TAJG

local WireLib = loadLibrary("wire")
local ChatLib = loadLibrary("chat")
local EntityLib = loadLibrary("ents")

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
	if O2 <= 15 and > 5 then
		print(string.format("You are running low on oxygen, you have %i percent left", O2))
	elseif O2 <= 5 and > 0 then
		print(string.format("You are running out of oxygen, you have %i percent left", O2))
	elseif O2 == 0 then
		print("You are out of oxygen")
	else print("Oxygen is OK!")
	end
	if PWR <= 15 and > 5 then
		print(string.format("You are running low on power, you have %i percent left", PWR))
	elseif PWR <= 5 and > 0 then
		print(string.format("You are running out of power, you have %i percent left", PWR))
	elseif PWR == 0 then
		print("You are out of power")
	else print("Oxygen is OK!")
	end
	if WTR <= 15 and > 5 then
		print(string.format("You are running low on water, you have %i percent left", WTR))
	elseif WTR <= 5 and > 0 then
		print(string.format("You are running out of water, you have %i percent left", WTR))
	elseif WTR == 0 then
		print("You are out of water")
	else print("Oxygen is OK!")
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