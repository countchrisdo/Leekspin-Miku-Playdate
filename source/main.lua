-- Init
import "CoreLibs/graphics"
import "CoreLibs/sprites"
-- localize playdate graphics for small performance gain + ease of use
local pd = playdate
local gfx = pd.graphics
-- localize playdate sound for small performance gain + ease of use
-- local gfs = pd.sound
-- local scoresfx = gfs.sampleplayer.new("sound/zap1")
-- local losssfx = gfs.sampleplayer.new("sound/zapThreeToneDown")
-- local startsfx = gfs.sampleplayer.new("sound/zapThreeToneUp")

-- Player
-- -- X is right / Y is down | Screen is 400x240
local imgX = 200
local imgY = 120
local mainImg = gfx.image.new("images/1")
local mainSprite = gfx.sprite.new(mainImg)
mainSprite:moveTo(imgX, imgY)
mainSprite:add()

-- Game State
local gameState = "stopped"
local crankSpd = 0

-- Update
-- -- Runs evert frame / PD runs 30fps
function pd.update()
    gfx.sprite.update()

    if gameState == "stopped" then
        gfx.drawTextAligned("Press A to start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = "active"
        end
    elseif gameState == "active" then
        crankSpd = pd.getCrankPosition()
        if crankSpd < 90 then
            print("Crank Speed hit /n crankSpd: " .. crankSpd)
        else
            print("Not fast enough /n crankSpd: " .. crankSpd)
        end
    end

    gfx.drawTextAligned("crankSpd: " .. crankSpd, 390, 10, kTextAlignment.right)
end
