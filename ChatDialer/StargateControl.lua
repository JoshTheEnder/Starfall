--@name The Stargate Controler
--@author TAJG

--[[
	####################################################################################
	#### Here it is, The Stargate Controller (ChatDialer V3). 			####
	#### The goal for this chip was to be more stabel then versions 		####
	#### At the start of writing this chip i set myself a goal, to not use any	####
	#### think hooks; using only the listener hook that Person8880 coded into 	####
	#### the stargate library and the ChatLib.listen hook :)			####					####
	####################################################################################
]]
local EntLib = loadLibrary("ents")
local SGLib = loadLibrary("stargate")
local ChatLib = loadLibrary("chat")
local TimeLib = loadLibrary("time")
local FindLib = loadLibrary("find")
local NetLib = loadLibrary("net")
local WireLib = loadLibrary("wire")
local SGList = SGLib.getAllStargates()
local Chip = EntLib.self()
local Owner = Chip:owner()
local Gate = Chip:isWeldedTo()
local Iris = Gate:iris()
local IDCList = { "12987" , "311" , "9799" }
local NameList = { "TAJG" , "Cookiemorph" , "Alex5511" } -- these should match up to the IDCList
local ColourRed = { 255, 0, 0 }
local Alex = FindLib.playerByName("Alex5511")
local Cookiemorph = FindLib.playerByName("Cookiemorph")
WireLib.createInputs( { "HUDEntity" } , { "entity" } )
Gate:accessList( { Owner, Alex, Cookiemorph } )
Gate:setLocal( false )
SGClass = Gate:class()

 

--Checks to see if the Gate is actually a gate

if SGClass:sub(1,8) == "Stargate" then
	printColor( {r=0,g=255,b=0}, "Good you spawned the chip on the gate")
elseif Gate ~= SGList[i] then
	printColor( {r=0,g=255,b=0}, "Please spawn it on the god damn gate! ¬_¬")
	error("You didnt spawn the chip on a Stargate!")
end



if Iris == nil then
	printColor({ r=255,g=0,b=0}, "Please Spawn an Iris on the gate!")
	error("Please spawn an Iris on the gate!")
elseif Iris ~= nil then
	printColor({r=0,g=255,b=0}, "Good, you have an Iris")
end

local function SearchIDC(IDC)
	Verified = false -- a single '=' defines a variable, '==' mean "is equal to", '~=' not equal to.
	for i=1, #IDCList do 
		if IDC == IDCList[i] then
    			Verified = true
    			IrisSet("open")
    			if NameList[i] == "TAJG" then
    				ChatLib.botSay("TAJG",{r=0,g=0,b=255}, "Hey master, you're back :) " )
    			else ChatLib.botSay("TAJG",{r=0,g=255,b=0}, string.format("Oh, hello %s, the iris is open :)", NameList[i] ) )
    			end
			break -- ends the for loop early
		end
	end
	if Verified == false then
		ChatLib.botSay("TAJG", {r=255, g=0, b=0}, "Your IDC was not recognised!" )
		TimeLib.stimer(2, function()
    			Gate:close()
		end)
	end
	Verified = false
end

function IrisSet(Params)
	if Params == "close" and SGLib.irisActive(Iris) == false then
    		printColor( {r=255,g=255,b=0}, "Closing the iris" )
		SGLib.irisToggle(Iris)
	elseif Params == "open" and SGLib.irisActive(Iris) == true then 
        	printColor( {r=255,g=255,b=0}, "Opening the iris" )
		SGLib.irisToggle(Iris)
    	end
end

function inboundStuffToDo(SG)
    IrisSet("close")
    Targate = Gate:target()
    TName = Targate:name()
    TAdd = Targate:address()
    ChatLib.botSay("TAJG", {r=255,g=0,b=0}, string.format("%s %q, Please send correct IDC or close the Stargate now", TName, TAdd) )
    if NetLib.start(WireLib.ports.HUDEntity) then
        NetLib.writeString("HUDInfoSend")
        NetLib.writeString( string.format("%s",TAdd) )
        NetLib.writeString( string.format("%s",TName) )
        NetLib.writeString("test")
        NetLib.send(Owner)
    end
end

function DialLeGate(Params) -- How to split strings.....
    ANum, MNum = Params:find("%s")
    Address = Params:sub(1, ANum)
    --Mode = Params:Sub(MNum)
    local DialMode = 1 -- Mode or 1
    printColor({r=0,g=128,b=128}, "Dialing: ", {r=0,g=0,b=255}, string.format("%s", Address:upper() ) )
    SGLib.dial(Gate, Address:upper(), DialMode)
end

function GetGateList()
    AddressList = SGLib.getAllStargates()
    for i = 1, #SGList do
        printColor({r=225,g=114,b=0},string.format("%i: Address: %s, Group: %s, Name: %s, Owner: %s", i, SGLib.address(SGList[i]), SGLib.group(SGList[i]), SGLib.name(SGList[i]), SGList[i]:owner() ) )    
    end
end

function Helper()
    Help = {
        "Chat commands: ",
        "/gd <ADDRESS> | Dials the gate to the specified address",
        "/ir <open OR close | Sets the iris to the specified state",
        "/gc | Closes the gate",
        "/sn <name> | Sets the gates name",
        "/sa <address> | Sets the gates address",
        "/sg <group> | Sets the gates group",
        "/hl | Displays this help",
        "/or | Overides the IDC checking system *this command and actual functionality comming soon*"}
    for i = 1, #Help do
        print( Help[i] )
    end
end

function ChatToCommand(Message, Player)
    if Player == Owner or Alex or Cookiemorph then
        Command = Message:sub(1, 3)
        Params = Message:sub(5)
        --print(string.format("%q", Command)) print(string.format("%q", Params))
        if Command == "/gd" then
            DialLeGate(Params)
        elseif Command == "/ir" then
            IrisSet(Params)
        elseif Command == "/gc" then
            Gate:close()
            ChatLib.tell(Player, {r=255,g=0,b=255}, "Closing the gate!" )
        elseif Command == "/sn" then
            Gate:setName(Params)
            ChatLib.tell(Player, {r=255,g=0,b=255}, string.format("Setting name to %q", Params ) )
        elseif Command == "/sa" then 
            Gate:setAddress(Params)
            ChatLib.tell(Player, {r=255,g=0,b=255}, string.format("Setting address to %q", Params ) )
        elseif Command == "/sg" then
            Gate:setGroup(Params)
            ChatLib.tell(Player, {r=255,g=0,b=255}, string.format("Setting group to %q", Params ) )
        elseif Command == "/hl" then
            Helper()
        elseif Command == "/gl" then
            GetGateList()
        end
    end
end

-- Listeners
Gate:listen(inboundStuffToDo)
ChatLib.listen(ChatToCommand)
Gate:listenForCode(SearchIDC, Gate)
--[[print("Testing")
ChatLib.botSay("TAJG","TEST")
]]--
ChatLib.botSay("TAJG","System Loaded, awaiting commands")
