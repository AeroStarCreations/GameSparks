local composer = require( "composer" )
local widget = require( "widget" )
local GS = require( "plugin.gamesparks" )

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
local loginAuth
local username
local password
 
local function loginUser() 
    loginAuth:setUserName( username.text )
    loginAuth:setPassword( password.text )

    loginAuth:send( function( authenticationResponse )
        if authenticationResponse:hasErrors() then
            for key, value in pairs(authenticationResponse:getErrors()) do
                print(key, value)
            end
        else 
            print( "Aunthentication success!" )
        end 
    end)

    print("-- loginUser()")
end

local function handleButtonEvent( event )
    if (event.phase == "ended") then
        if (event.target.id == "login") then
            if (username.text == nil or username.text == "" or
            password.text == nil or password.text == "") then
                print( "Must fill all fields" )
            else 
                loginUser();
            end
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
    loginAuth = requestBuilder.createAuthenticationRequest()

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        -- ex: before the scene transition begins
        local numOfItems = 3

        username = native.newTextField(w/2, h/(numOfItems+1), w/1.4, h/20)
        username.placeholder = "(Username)"

        password = native.newTextField(w/2, 2 * username.y, w/1.4, h/20)
        password.placeholder = "(Password)"

        local button1 = widget.newButton({
            id = "login",
            x = w / 2,
            y = 3 * username.y,
            width = w/1.4,
            height = 2 * username.height,
            label = "Log In",
            fontSize = username.height,
            shape = "roundedRect",
            cornerRadius = username.height * 2 / 3 ,
            onEvent = handleButtonEvent,
        })

        sceneGroup:insert( username )
        sceneGroup:insert( password )
        sceneGroup:insert( button1 )
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        -- ex: after the scene transition completes
 
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