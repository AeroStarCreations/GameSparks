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

local function handleButtonEvent( event ) 
    if (event.phase == "ended") then
        if (event.target.id == "login") then
            composer.gotoScene( "loginScene" )
        elseif (event.target.id == "register") then
            composer.gotoScene( "registerScene" )
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
    gs = createGS()
    gs.setApiKey( "x351935KVecu" )
    gs.setApiSecret( "RSMked0zUwwKqS0baxkktSpt9mNoDN1j" )
    gs.setApiCredential( "device" )
    gs.connect()

    requestBuilder = gs.getRequestBuilder()

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        -- ex: before the scene transition begins
        local numOfButtons = 2
        local buttonW = w / 2
        local buttonH = buttonW / 4
        local buttonFontSize = buttonH / 2
        local buttonCornerRadius = buttonH / 3

        local button1 = widget.newButton({
            id = "login",
            x = w / 2,
            y = h / (numOfButtons + 1),
            width = buttonW,
            height = buttonH,
            label = "Log In",
            fontSize = buttonFontSize,
            shape = "roundedRect",
            cornerRadius = buttonCornerRadius,
            onEvent = handleButtonEvent,
        })

        local button2 = widget.newButton({
            id = "register",
            x = w / 2,
            y = 2 * button1.y,
            width = buttonW,
            height = buttonH,
            label = "Register",
            fontSize = buttonFontSize,
            shape = "roundedRect",
            cornerRadius = buttonCornerRadius,
            onEvent = handleButtonEvent,
        })

        sceneGroup:insert( button1 )
        sceneGroup:insert( button2 )

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        -- ex: after the scene transition completes
        print( "Authenticated: " .. tostring(gs.isAuthenticated()))
        if (gs.isAuthenticated()) then
            playerDetails = requestBuilder.createAccountDetailsRequest()
            playerDetails:send( function(response)
                print( "Display name: " .. response.data.displayName )
            end)
        end
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