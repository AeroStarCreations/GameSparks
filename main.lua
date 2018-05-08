-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local  composer = require("composer")
local GS = require( "plugin.gamesparks" )

display.setStatusBar( display.HiddenStatusBar )

composer.isDebug = true

----
-- Manual debugging
----
infoText = display.newText({
    text = "Info Text",
    x = display.actualContentWidth / 2,
    y = 0,
    width = w,
    height = 0,
    align = "center",
})
infoText:setFillColor( 0.9, 0.3, 0.3 )
infoText.anchorY = 0
infoText.y = display.safeScreenOriginY

function infoUpdate( text )
    infoText.text = infoText.text .. "\n" .. text
end

function infoClear()
    infoText.text = ""
end

----
-- GameSparks
----
local function writeText( string ) 
    print( string )
end

local function availabilityCallback( isAvailable ) 
    writeText( "Availability: " .. tostring(isAvailable) .. "\n")

    if isAvailable then
    -- Do something
    end
end

gs = createGS()
gs.setLogger( writeText )
gs.setApiKey( "x351935KVecu" )
gs.setApiSecret( "RSMked0zUwwKqS0baxkktSpt9mNoDN1j" )
gs.setApiCredential( "device" )
gs.setAvailabilityCallback( availabilityCallback )
gs.connect()

composer.gotoScene( "loginOrRegisterScene" )
