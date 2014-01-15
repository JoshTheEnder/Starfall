--@name Get Stargate info
--@author JoshTheEnder

local sg = loadLibrary("stargate")
local ents = loadLibrary("ents")

StrGts = sg.getAllStargates() -- prints a list of all gates on the map to the console
for i = 1, #StrGts do
    printConsole(string.format("%i: Address: %s, Group: %s, Name: %s, Owner: %s", i, sg.address(StrGts[i]), sg.group(StrGts[i]), sg.name(StrGts[i]), StrGts[i]:owner() ) )    
end

function TellMeGateStuff(Gate) -- gets called when a stargate recieves an inbound wormhole
    local Targate = Gate:target() -- i'm so good with names :)
    printColor("[SG Info] ", {r=255,g=0,b=255}, string.format("Outbound conneciton from %s%s %q Owned by [%s] to %s%s %q Owned by [%s]", Targate:address(),Targate:group(),Targate:name(), Targate:owner(), Gate:address(),Gate:group(),Gate:name(), Gate:owner() ) )
end
sg.listen(TellMeGateStuff)
