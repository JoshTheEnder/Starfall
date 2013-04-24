--@name SG Screen
--@author TAJG
--@sharedscreen

local NetLib = loadLibrary( "net" )
local ClientData = { }

function NetStuff() -- having it in a shared function is easier to add to the things to send
    if CLIENT then
        if ( NetLib.readString() == "StartData" ) then
            ClientData["DiallingAddress"] = NetLib.readString()
            ClientData["DiallingSymbol"] = NetLib.readString()
            ClientData["ChevronsEncoded"] = NetLib.readString()
            ClientData["IrisStatus"] = NetLib.readString()
            ClientData["GateOpen"] = NetLib.readString()
        end
    elseif SERVER then
        if NetLib.start() == true then
            NetLib.writeString( "StartData" )
            NetLib.writeString( string.format( "%s", DiallingAddress ) )
            NetLib.writeString( string.format( "%s", DiallingSymbol ) )
            NetLib.writeString( string.format( "%s", ChevronsEncoded ) )
            NetLib.writeString( string.format( "%s", IrisStatus ) )
            NetLib.writeString( string.format( "%s", GetOpen ) )
            NetLib.broadcast()
        end
    end
end


if SERVER then

    local WireLib = loadLibrary( "wire" )
    local SGLib = loadLibrary( "stargate" )
    WireLib.createInputs( { "Stargate" } , { "wirelink" } )
    Stargate = WireLib.ports.Stargate
    Gate = Stargate:entity()
    Iris = Gate:iris()

    
    print( string.format( "%s", Gate:class() ) )

    hook( "think", "thinking", function()
        DiallingAddress = Stargate["Dialing Address"]
        DiallingSymbol = Stargate["Dialing Symbol"]
        ChevronsEncoded = Stargate["Chevrons"]
        if Gate:open() == true then
            GetOpen = "Open"
        else
            GetOpen = "Closed"
        end
        if SGLib.irisActive( Iris ) == true then
            IrisStatus = "Active"
        elseif SGLib.irisActive( Iris ) == false then
            IrisStatus = "Inactive"
        end
        NetStuff()
    end)

end

if CLIENT then
    
    local RenderLib = loadLibrary( "render" )

    function ChBox1( State )
        if State == true then
            RenderLib.setColor( 255, 0, 0, 255 )
        elseif State == false then
            RenderLib.setColor( 0, 0, 255, 255 )
        end
        RenderLib.drawRectOutline( 444, 10, 60, 60 )
    end
        
    function ChBox2( State )
        if State == true then
            RenderLib.setColor( 255, 0, 0, 255 )
        elseif State == false then
            RenderLib.setColor( 0, 0, 255, 255 )
        end
        RenderLib.drawRectOutline( 444, 80, 60, 60 )
    end

    function ChBox3( State )
        if State == true then
            RenderLib.setColor( 255, 0, 0, 255 )
        elseif State == false then
            RenderLib.setColor( 0, 0, 255, 255 )
        end
        RenderLib.drawRectOutline( 444, 150, 60, 60 )
    end

    function ChBox4( State )
        if State == true then
            RenderLib.setColor( 255, 0, 0, 255 )
        elseif State == false then
            RenderLib.setColor( 0, 0, 255, 255 )
        end
        RenderLib.drawRectOutline( 514, 150, 60, 60 )
    end

    hook( "net", "Receiveing Data", NetStuff )


    hook("render", "Displaying stuff", function()
        RenderLib.clear()
        ChBox1( false )
        ChBox2( true )
        ChBox3( false )
    end)

end
