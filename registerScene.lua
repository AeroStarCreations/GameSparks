local composer = require( "composer" )
local widget = require( "widget" )

widget.setTheme( "widget_theme_ios7" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local w = display.actualContentWidth
local h = display.actualContentHeight

local function handleButtonEvent( event ) 
    if (event.phase == "ended") then
        if (event.target.id == "emailpassword") then
            composer.gotoScene( "usernameRegisterScene" )
        elseif (event.target.id == "facebook") then

        elseif (event.target.id == "google") then

        elseif (event.target.id == "back") then
            composer.gotoScene( composer.getSceneName( "previous" ))
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

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        -- ex: before the scene transition begins

        local numOfButtons = 4
        local buttonW = w / 2
        local buttonH = buttonW / 4
        local buttonFontSize = buttonH / 2
        local buttonCornerRadius = buttonH / 3

        local button1 = widget.newButton({
            id = "emailpassword",
            x = w / 2,
            y = h / (numOfButtons + 1),
            width = buttonW,
            height = buttonH,
            label = "Email/Password",
            fontSize = buttonFontSize,
            shape = "roundedRect",
            cornerRadius = buttonCornerRadius,
            onEvent = handleButtonEvent,
        })

        local button2 = widget.newButton({
            id = "facebook",
            x = w / 2,
            y = 2 * button1.y,
            width = buttonW,
            height = buttonH,
            label = "Facebook",
            fontSize = buttonFontSize,
            shape = "roundedRect",
            cornerRadius = buttonCornerRadius,
            onEvent = handleButtonEvent,
        })

        local button3 = widget.newButton({
            id = "google",
            x = w / 2,
            y = 3 * button1.y,
            width = buttonW,
            height = buttonH,
            label = "Google",
            fontSize = buttonFontSize,
            shape = "roundedRect",
            cornerRadius = buttonCornerRadius,
            onEvent = handleButtonEvent,
        })

        local button4 = widget.newButton({
            id = "back",
            x = w / 2,
            y = 4 * button1.y,
            width = buttonW,
            height = buttonH,
            label = "Back",
            fontSize = buttonFontSize,
            shape = "roundedRect",
            cornerRadius = buttonCornerRadius,
            onEvent = handleButtonEvent,
        })

        sceneGroup:insert( button1 )
        sceneGroup:insert( button2 )
        sceneGroup:insert( button3 )
        sceneGroup:insert( button4 )
 
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