local composer = require( "composer" )
local widget = require( "widget" )
local GS = require( "plugin.gamesparks" )
local g = require ( "globals" )
local GGData = require( "GGData" )

widget.setTheme( "widget_theme_ios7" ) 
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local w = display.actualContentWidth
local h = display.actualContentHeight
local requestBuilder
local color
local number
local food
 
local function clearTextFields()
    color.text = ""
    number.text = ""
    food.text = ""
end

local function submitUserData()
    local submitDataRequest = requestBuilder.createLogEventRequest()
    submitDataRequest:setEventKey( "Set_Player_Data" )
    submitDataRequest:setEventAttribute( "playerData", {
        color = color.text,
        number = number.text,
        food = food.text
    })
    submitDataRequest:send( function(response)
        g.printTable( response )
    end)
end

local function getUserData()
    local getDataRequest = requestBuilder.createLogEventRequest()
    getDataRequest:setEventKey( "Get_Player_Data" )
    getDataRequest:send( function(response)
        local data = response:getScriptData().playerData
        color.text = data.color
        number.text = data.number
        food.text = data.food
    end)
end

local function handleButtonEvent( event )
    if (event.phase == "ended") then
        infoClear()
        infoUpdate(event.target.id .. " pressed")
        if (event.target.id == "submit") then
            submitUserData()
        elseif (event.target.id == "get") then
            getUserData()
        elseif (event.target.id == "clear") then
            clearTextFields()
        elseif (event.target.id == "back") then
            composer.gotoScene( composer.getSceneName( "previous" ))
        end
    end
end

local function inputListener( event )
    infoClear()
    if (event.phase == "submitted" or event.phase == "ended") then
        if (event.target.id == "color") then
            infoUpdate("color entered")
            native.setKeyboardFocus( number )
        elseif (event.target.id == "number") then
            infoUpdate("number entered")
            native.setKeyboardFocus( food )
        elseif (event.target.id == "food") then
            infoUpdate("food entered")
            native.setKeyboardFocus( nil )
            -- handleButtonEvent({phase="ended", target={id="submit"}})
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
    requestBuilder = gs.getRequestBuilder()

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        -- ex: before the scene transition begins
        local numOfItems = 7

        color = native.newTextField(w/2, h/(numOfItems+1), w/1.4, h/20)
        color.placeholder = "(color)"
        color.id = "color"
        color:addEventListener( "userInput", inputListener )

        number = native.newTextField(w/2, 2 * color.y, w/1.4, h/20)
        number.placeholder = "(number)"
        number.id = "number"
        number.inputType = "number"
        number:addEventListener( "userInput", inputListener )

        food = native.newTextField(w/2, 3 * color.y, w/1.4, h/20)
        food.placeholder = "(food)"
        food.id = "food"
        food:addEventListener( "userInput", inputListener )

        local button1 = widget.newButton({
            id = "submit",
            x = w / 2,
            y = 4 * color.y,
            width = w/1.4,
            height = 2 * color.height,
            label = "Submit",
            fontSize = color.height,
            shape = "roundedRect",
            cornerRadius = color.height * 2 / 3,
            onEvent = handleButtonEvent,
        })

        local button2 = widget.newButton({
            id = "get",
            x = w / 2,
            y = 5 * color.y,
            width = w/1.4,
            height = 2 * color.height,
            label = "Get",
            fontSize = color.height,
            shape = "roundedRect",
            cornerRadius = color.height * 2 / 3,
            onEvent = handleButtonEvent,
        })

        local button3 = widget.newButton({
            id = "clear",
            x = w / 2,
            y = 6 * color.y,
            width = w/1.4,
            height = 2 * color.height,
            label = "Clear",
            fontSize = color.height,
            shape = "roundedRect",
            cornerRadius = color.height * 2 / 3,
            onEvent = handleButtonEvent,
        })

        local button4 = widget.newButton({
            id = "back",
            x = w / 2,
            y = 7 * color.y,
            width = w/1.4,
            height = 2 * color.height,
            label = "Back",
            fontSize = color.height,
            shape = "roundedRect",
            cornerRadius = color.height * 2 / 3,
            onEvent = handleButtonEvent,
        })

        sceneGroup:insert( color )
        sceneGroup:insert( number )
        sceneGroup:insert( food )
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
        color:removeSelf()
        number:removeSelf()
        food:removeSelf()
        
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