--@name Ultimate Control
--@author TAJG

local WireLib = loadLibrary("wire")
local ChatLib = loadLibrary("chat")
local EntityLib = loadLibrary("ents")

WireLib.createInputs({"ResourceCache","LSCore","WaterSplitter","WaterPump"},{"wirelink","wirelink","wirelink","wirelink"})

-- Modules
LS = false -- LSCore, WaterSplitter, WaterPump operations {REQUIRES RD TO WORK}
RD = false -- Resource stuff, like energy and other resources
SG = false -- Stargate and ring stuff 


function getPercent(Value1, Value2)
	local Total = Value1 / Value2 * 100
	return Total
end


function StargateModule()
	do stargate stuff...

end

function LifeSupportModule()
	do life support stuff...

end

function ResourceMontoringModule()
	do Resource stuff...

end


-- Loading of moduals for hooking
if LS = true then
	hook("input","LifeSupport", LifeSupportModule() )
end

if RD = true then
	hook("input","ResourceDistrobution", ResourceMontoringModule() )
end 