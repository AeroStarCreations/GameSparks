local composer = require( "composer" )
local widget = require( "widget" )
local GS = require( "plugin.gamesparks" )
local google = require( "plugin.googleSignIn" )

widget.setTheme( "widget_theme_ios7" )
google.init()
 
local androidClientID = "635193827138-jkdpehplsn5tjdini920hn7n3fjc3poj.apps.googleusercontent.com"
local clientID = "635193827138-8q04oidpj9a0rj81bvm8o5fd8caq04cv.apps.googleusercontent.com" -- iOS default
if (system.getInfo("platform") == "android") then
    clientID = androidClientID
end

local scene = composer.newScene()
   
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local w = display.actualContentWidth
local h = display.actualContentHeight
local requestBuilder
local registerRequest
local button1

local function handleButtonEvent( event )
    if (event.phase == "ended") then
        if (event.target.id == "register") then
            infoUpdate( "Google Register" )
            google.signIn(clientID, nil, nil, function(e)
                if(e.isError == true) then
                    print("-------error")
                else
                    print("-------no error")
                end
                print("-------google listener")
            end)
        elseif (event.target.id == "back") then
            composer.gotoScene( composer.getSceneName( "previous" ))
        end
        print(event.target.id .. " button pressed")
    end
end

local function registerWithGameSparks( token )
    registerRequest:setAccessToken( token )

    registerRequest:send( function( authenticationResponse) end)
end

local function googleListener( event )
    infoClear()
    infoUpdate( "Google Listener" )
    for k,v in pairs(event) do
        infoUpdate(k, v)
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
    registerRequest = requestBuilder.createFacebookConnectRequest()

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        -- ex: before the scene transition begins
        local numOfItems = 2

        button1 = widget.newButton({
            id = "register",
            x = w / 2,
            y = h / (numOfItems + 1),
            width = w/1.4,
            height = w / 4,
            label = "Register With\nGoogle",
            labelAlign = "center",
            fontSize = w / 12,
            shape = "roundedRect",
            cornerRadius = w / 4 * 2 / 3,
            onEvent = handleButtonEvent,
        })

        local button2 = widget.newButton({
            id = "back",
            x = w / 2,
            y = 2 * button1.y,
            width = w / 1.4,
            height = w / 4,
            label = "Back",
            fontSize = w / 12,
            shape = "roundedRect",
            cornerRadius = w / 4 * 2 / 3,
            onEvent = handleButtonEvent,
        })

        sceneGroup:insert( button1 )
        sceneGroup:insert( button2 )
 
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