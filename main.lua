-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local  composer = require("composer")
local GS = require( "plugin.gamesparks" )
local GGData = require( "GGData" )

display.setStatusBar( display.HiddenStatusBar )

composer.isDebug = true

----
-- Local data
----
local data = GGData:new( "appData" )
if not data.isLoggedIn then data.isLoggedIn = false end
if not data.signInMethod then data.signInMethod = nil end
if not data.authToken then data.authToken = nil end
data:save()
-- signInMethod values: facebook, email, google

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

local function authenticatedCallback( playerId )
    if playerID then
        print( "Player ID: " .. playerId )
    end
end

gs = createGS()
gs.setLogger( writeText )
gs.setApiKey( "x351935KVecu" )
gs.setApiSecret( "RSMked0zUwwKqS0baxkktSpt9mNoDN1j" )
gs.setApiCredential( "device" )
gs.setUseLiveServices( false )
gs.setAvailabilityCallback( availabilityCallback )
gs.setAuthenticatedCallback( authenticatedCallback )
-- Check for authToken (this is needed to persist login)
if ( data.isLoggedIn and data.authToken ) then
    gs.setAuthToken( data.authToken )
end
----
gs.connect()

composer.gotoScene( "loginOrRegisterScene" )
