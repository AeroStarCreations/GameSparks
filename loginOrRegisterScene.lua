local composer = require( "composer" )
local widget = require( "widget" )
local GS = require( "plugin.gamesparks" )
local g = require ( "globals" )

widget.setTheme( "widget_theme_ios7" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local w = display.actualContentWidth
local h = display.actualContentHeight
local requestBuilder
local button1
local timers = {}

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

        button1 = widget.newButton({
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
        infoClear()
        infoUpdate( "not authenticated" )
        local function checkAuthentication( event )
            if (gs.isAuthenticated()) then
                -- Get account information
                playerDetails = requestBuilder.createAccountDetailsRequest()
                playerDetails:send( function(response)
                    infoClear()
                    local t = "Welcome"
                    if (response.data.displayName) then
                        t = t .. " " .. response.data.displayName
                        print( "Display name: " .. response.data.displayName )
                    end
                    infoUpdate( t .. "!" )
                end)
                -- Cancel timer
                timer.cancel( event.source )
                event.source = nil
                -- Disable login button (commented for testing)
                -- button1.alpha = 0.5
                -- button1:setEnabled( false )
                print( "Authenticated: true" )
            end
        end
        timers.authTimer = timer.performWithDelay( 500, checkAuthentication, -1)
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
        for k,v in pairs( timers ) do 
            timer.cancel( v )
            v = nil
        end
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