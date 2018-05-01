-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local  composer = require("composer")

display.setStatusBar( display.HiddenStatusBar )

composer.isDebug = true

composer.gotoScene( "loginOrRegisterScene" )

infoText = display.newText({
    text = "Info Text",
    x = display.actualContentWidth / 2,
    y = 0,
    width = w,
    height = 0,
    align = "center",
})
infoText.anchorY = 0
infoText.y = display.safeScreenOriginY

function infoUpdate( text )
    infoText.text = infoText.text .. "\n" .. text
end

function infoClear()
    infoText.text = ""
end