-- Init
import "CoreLibs/graphics"
import "CoreLibs/sprites"
-- localize playdate graphics for small performance gain + ease of use
local pd = playdate
local gfx = pd.graphics
-- localize playdate sound for small performance gain + ease of use
local gfs = pd.sound
local scoresfx = gfs.sampleplayer.new("sound/zap1")
local losssfx = gfs.sampleplayer.new("sound/zapThreeToneDown")
local startsfx = gfs.sampleplayer.new("sound/zapThreeToneUp")

-- Player
-- -- X is right / Y is down | Screen is 400x240
-- -- Vars are global by default so we set these to local
local playerStartX = 40
local playerStartY = 120
local playerSpeed = 3
local playerImage = gfx.image.new("images/gup")
local playerSprite = gfx.sprite.new(playerImage)
playerSprite:setCollideRect(4, 4, 60, 60)
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

-- Game State
local gameState = "stopped"
local score = 0

-- Obstacle
local obstacleSpeed = 5
local obsicaleImage = gfx.image.new("images/fisheye")
local obstacleSprite = gfx.sprite.new(obsicaleImage)
obstacleSprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap
obstacleSprite:setCollideRect(0, 0, 40, 40)
obstacleSprite:moveTo(450, 240)
obstacleSprite:add()

-- Update
-- -- Runs evert frame / PD runs 30fps
function pd.update()
    gfx.sprite.update()

    if gameState == "stopped" then
        gfx.drawTextAligned("Press A to start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = "active"
            startsfx:play()
            score = 0
            obstacleSpeed = 5
            playerSprite:moveTo(playerStartX, playerStartY)
            obstacleSprite:moveTo(450, math.random(40, 200))
        end
    elseif gameState == "active" then
        local crankPosition = pd.getCrankPosition()
        if crankPosition <= 90 or crankPosition >= 270 then
            playerSprite:moveBy(0, -playerSpeed)
        else
            playerSprite:moveBy(0, playerSpeed)
        end

        local actualX, actualY, collisions, length = obstacleSprite:moveWithCollisions(obstacleSprite.x - obstacleSpeed, obstacleSprite.y)
        if obstacleSprite.x < -20 then
            obstacleSprite:moveTo(450, math.random(40, 200))
            score += 1
            scoresfx:play()
            obstacleSpeed += 0.2
            print("obstacleSpeed: " .. obstacleSpeed)
        end

        if length > 0 or playerSprite.y > 270 or playerSprite.y < -30 then
            gameState = "stopped"
            losssfx:play()
        end
    end

    gfx.drawTextAligned("Score: " .. score, 390, 10, kTextAlignment.right)
end
