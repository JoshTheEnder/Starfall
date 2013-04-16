--@name SG Screen
--@author TAJG
--@sharedscreen

local NetLib = loadLibrary("net")


if SERVER then
    local WireLib = loadLibrary("wire")
    local SGLib = loadLibrary("stargate")
    WireLib.createInputs( { "Stargate" } , { "wirelink" } )
    Stargate = WireLib.ports.Stargate
    Gate = Stargate:entity()
    Iris = Gate:iris()
    DiallingAddress = Stargate["Dialing Address"]
    DiallingSymbol = Stargate["Dialing Symbol"]
    
    print(string.format("%s", Gate:class() ) )

end

if CLIENT then
    
    local RenderLib = loadLibrary("render")

    function ChBox1(State)
        if State == true then
        RenderLib.setColor(255,0,0,255)
        elseif State == false then
        RenderLib.setColor(0,0,255,255)
        end
        RenderLib.drawRectOutline(444, 10, 60, 60)
    end
        
    function ChBox2(State)
        if State == true then
        RenderLib.setColor(255,0,0,255)
        elseif State == false then
        RenderLib.setColor(0,0,255,255)
        end
        RenderLib.drawRectOutline(444, 80, 60, 60)
    end

    function ChBox3(State)
        if State == true then
        RenderLib.setColor(255,0,0,255)
        elseif State == false then
        RenderLib.setColor(0,0,255,255)
        end
        RenderLib.drawRectOutline(444, 150, 60, 60)
    end

    function ChBox4(State)
        if State == true then
        RenderLib.setColor(255,0,0,255)
        elseif State == false then
        RenderLib.setColor(0,0,255,255)
        end
        RenderLib.drawRectOutline(514, 150, 60, 60)
    end

    hook("render", "Displaying stuff", function()
    RenderLib.clear()
    ChBox1(false)
    ChBox2(true)
    ChBox3(false)
    end)

end
