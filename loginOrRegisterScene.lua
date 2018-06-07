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
-- Local Variables
local data = GGData:new( "appData" )
local w = display.actualContentWidth
local h = display.actualContentHeight
local requestBuilder
local button1
local button3
local timers = {}
local buttonIsLogin = true

-- Functions
local loginLogoutHandler
local logOut
local switchLogoutButtonToLogin
local startAuthTimer

local function handleButtonEvent( event ) 
    if (event.phase == "ended") then
        if (event.target.id == "login") then
            loginLogoutHandler()
        elseif (event.target.id == "register") then
            composer.gotoScene( "registerScene" )
        elseif (event.target.id == "data") then
            composer.gotoScene( "userDataScene" )
        end
        print(event.target.id .. " button pressed")
    end
end
 
local function enableUserDataButton()
    button3:setEnabled( true )
    button3.alpha = 1
end

local function disableUserDataButton()
    button3:setEnabled( false )
    button3.alpha = 0.5
end

function loginLogoutHandler()
    if buttonIsLogin then
        composer.gotoScene( "loginScene" )
    else
        logOut()
    end
end

function logOut()
    local logoutRequest = requestBuilder.createLogEventRequest()
    logoutRequest:setEventKey( "Log_Out" )
    logoutRequest:send( function(response)
        print( "LOGOUT" )
        g.printTable( response )
    end)
    data.isLoggedIn = false
    data.authToken = 0
    data:save()
    switchLogoutButtonToLogin()
    startAuthTimer()
end

local function switchLoginButtonToLogout()
    button1:setLabel( "Log Out" )
    buttonIsLogin = false
end

function switchLogoutButtonToLogin()
    button1:setLabel( "Log In" )
    buttonIsLogin = true
end
  
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
        switchLoginButtonToLogout()
        enableUserDataButton()
        -- Cancel timer
        timer.cancel( event.source )
        event.source = nil
        print( "Authenticated: true" )
    end
end

function startAuthTimer()
    infoClear()
    infoUpdate( "not authenticated" )
    timers.authTimer = timer.performWithDelay( 1000, checkAuthentication, -1)
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
        local numOfButtons = 3
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

        button3 = widget.newButton({
            id = "data",
            x = w / 2,
            y = 3 * button1.y,
            width = buttonW,
            height = buttonH,
            label = "User Data",
            fontSize = buttonFontSize,
            shape = "roundedRect",
            cornerRadius = buttonCornerRadius,
            onEvent = handleButtonEvent,
        })
        disableUserDataButton()

        sceneGroup:insert( button1 )
        sceneGroup:insert( button2 )
        sceneGroup:insert( button3 )

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        -- ex: after the scene transition completes
        startAuthTimer()
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