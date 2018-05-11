local composer = require( "composer" )
local widget = require( "widget" )
local GS = require( "plugin.gamesparks" )
local GGData = require( "GGData" )

widget.setTheme( "widget_theme_ios7" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local w = display.actualContentWidth
local h = display.actualContentHeight
local data = GGData:new( "appData" )
local requestBuilder
local registerRequest
local displayName
local username
local password
 
local function registerUser() 
    registerRequest:setDisplayName( displayName.text )
    registerRequest:setUserName( username.text )
    registerRequest:setPassword( password.text )

    registerRequest:send( function( authenticationResponse )
        if not authenticationResponse:hasErrors() then
            data.signInMethod = "email"
            data.isLoggedIn = true
            data.authToken = authenticationResponse.authToken
            data:save()
            print( response:getUserName() " has successfully registered!")
        else
            for key,value in pairs(authenticationResponse:getErrors()) do
                print(key,value)
            end
        end
    end)

    print("-- registerUser()")
end

local function handleButtonEvent( event )
    if (event.phase == "ended") then
        if (event.target.id == "register") then
            if (displayName.text == nil or displayName.text == "" or
            username.text == nil or username.text == "" or
            password.text == nil or password.text == "") then
                print( "Must fill all fields" )
            else 
                registerUser();
            end
        end
        print(event.target.id .. " button pressed")
    end
end

 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    requestBuilder = gs.getRequestBuilder()
    registerRequest = requestBuilder.createRegistrationRequest()

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        -- ex: before the scene transition begins
        local numOfItems = 4

        displayName = native.newTextField(w/2, h/(numOfItems+1), w/1.4, h/20)
        displayName.placeholder = "(Display Name)"

        username = native.newTextField(w/2, 2 * displayName.y, w/1.4, h/20)
        username.placeholder = "(Username)"

        password = native.newTextField(w/2, 3 * displayName.y, w/1.4, h/20)
        password.placeholder = "(Password)"

        local button1 = widget.newButton({
            id = "register",
            x = w / 2,
            y = 4 * displayName.y,
            width = w/1.4,
            height = 2 * displayName.height,
            label = "Register",
            fontSize = displayName.height,
            shape = "roundedRect",
            cornerRadius = displayName.height * 2 / 3 ,
            onEvent = handleButtonEvent,
        })

        sceneGroup:insert( displayName )
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