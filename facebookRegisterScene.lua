local composer = require( "composer" )
local widget = require( "widget" )
local GS = require( "plugin.gamesparks" )
local facebook = require( "plugin.facebook.v4a" )

widget.setTheme( "widget_theme_ios7" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local w = display.actualContentWidth
local h = display.actualContentHeight
local gs
local requestBuilder
local registerRequest
local infoText
local button1

local function handleButtonEvent( event )
    if (event.phase == "ended") then
        if (event.target.id == "register") then
            if (facebook.isActive) then 
                if (facebook.getCurrentAccessToken() == nil) then
                    infoText.text = infoText.text .. "\nRegistration required"
                    facebook.login()
                else
                    infoText.text = infoText.text .. "\nAlready registered"
                end
            else
                infoText.text = infoText.text .. "\nFB not active"
            end
        elseif (event.target.id == "back") then
            composer.gotoScene( composer.getSceneName( "previous" ))
        end
        print(event.target.id .. " button pressed")
    end
end

local function writeText( string ) 
    print( string )
end

local function availabilityCallback( isAvailable ) 
    writeText( "Availability: " .. tostring(isAvailable) .. "\n")

    if isAvailable then
    -- Do something
    end
end

local function registerWithGameSparks( token )
    registerRequest:setAccessToken( token )
    registerRequest:setSwitchIfPossible( true )
    registerRequest:setSyncDisplayName( true )

    registerRequest:send( function( authenticationResponse)
         infoText.text = infoText.text .. "\n" .. authenticationResponse
    end)
end

local function facebookListener( event )
    if ( "fbinit" == event.name ) then
        infoText.text = infoText.text .. "\nFacebook initialized"
        -- Initialization complete
        button1.alpha = 1
        button1:setEnabled( true )
    elseif ( "fbconnect" == event.name ) then
        infoText.text = infoText.text .. "\nFacebook connected"
        if ( "session" == event.type ) then
            infoText.text = infoText.text .. "\nFacebook session"
            -- Handle login event
            if ("login" == event.phase) then
                infoText.text = infoText.text .. "\nGameSparks login"
                registerWithGameSparks(event.token)
            end
        elseif ( "dialog" == event.type ) then
            infoText.text = infoText.text .. "\nFacebook dialog"
            -- Handle dialog event
        end
    end
end

 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    gs = createGS()
    gs.setLogger( writeText )
    gs.setApiKey( "x351935KVecu" )
    gs.setApiSecret( "RSMked0zUwwKqS0baxkktSpt9mNoDN1j" )
    gs.setApiCredential( "device" )
    gs.setAvailabilityCallback( availabilityCallback )
    gs.connect()

    requestBuilder = gs.getRequestBuilder()
    registerRequest = requestBuilder.createFacebookConnectRequest()

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        -- ex: before the scene transition begins
        local numOfItems = 3

        infoText = display.newText({
            text = "Info Text",
            x = w / 2,
            y = h / (numOfItems + 1),
            width = w,
            height = 0,
            align = "center",
        })

        button1 = widget.newButton({
            id = "register",
            x = w / 2,
            y = 2 * infoText.y,
            width = w/1.4,
            height = w / 4,
            label = "Register With\nFacebook",
            labelAlign = "center",
            fontSize = w / 12,
            shape = "roundedRect",
            cornerRadius = w / 4 * 2 / 3,
            isEnabled = false;
            onEvent = handleButtonEvent,
        })
        button1.alpha = 0.2

        local button2 = widget.newButton({
            id = "back",
            x = w / 2,
            y = 3 * infoText.y,
            width = w / 1.4,
            height = w / 4,
            label = "Back",
            fontSize = w / 12,
            shape = "roundedRect",
            cornerRadius = w / 4 * 2 / 3,
            onEvent = handleButtonEvent,
        })

        sceneGroup:insert( infoText )
        sceneGroup:insert( button1 )
        sceneGroup:insert( button2 )
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        -- ex: after the scene transition completes
        facebook:init( facebookListener )

    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene