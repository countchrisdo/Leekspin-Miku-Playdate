-- Init
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
-- localize playdate graphics for small performance gain + ease of use
local pd = playdate
local gfx = pd.graphics

-- Load
-- -- X is right / Y is down | Screen is 400x240
local imgX = 200
local imgY = 120
local mainImg1 = gfx.image.new("images/1")
local mainImg2 = gfx.image.new("images/2")
local mainImg3 = gfx.image.new("images/3")
local mainImg4 = gfx.image.new("images/4")
local mainImgs = {mainImg1, mainImg2, mainImg3, mainImg4}
local mainSprite = gfx.sprite.new(mainImgs[1])
mainSprite:moveTo(imgX, imgY)
mainSprite:add()

-- Audio
-- -- localize playdate sound for small performance gain + ease of use
local gfs = pd.sound
local music = gfs.sampleplayer.new("sound/mikuLoop")
local playbackSpd = 0
local maxPlaybackSpd = 3
local scalingFactor = 90 -- Adjust to change sensitivity of crank
music:play(0,playbackSpd) -- loop forever, 0% playback speed

-- Game State
local crankSpd = 0
local TPR = 6 -- Ticks per Revolution
local currentImgIdx = 1

-- Update
-- -- Runs evert frame / PD runs 30fps
function pd.update()
    gfx.sprite.update()

    local crankChange, acceleratedChange = pd.getCrankChange()

    -- Calculate playback speed based on crank change
    print("Accelerated Change: " .. acceleratedChange)
    playbackSpd = acceleratedChange / scalingFactor * maxPlaybackSpd
    print("Playback Speed: " .. playbackSpd)

    -- Ensure playback speed is within bounds
    if playbackSpd > maxPlaybackSpd then
        playbackSpd = maxPlaybackSpd
    elseif playbackSpd < -maxPlaybackSpd then
        playbackSpd = -maxPlaybackSpd
    end

    music:setRate(playbackSpd)

    local crankTicks = playdate.getCrankTicks(TPR)
    print("Crank Ticks: " .. crankTicks)

    -- Change image based on crank ticksPerRevolution
    if crankTicks == 1 then
        print("Forward tick")
        currentImgIdx = currentImgIdx + 1
        if currentImgIdx > #mainImgs then
            currentImgIdx = 1
        end
        mainSprite:setImage(mainImgs[currentImgIdx])
    elseif crankTicks == -1 then
        print("Backwards tick")
        currentImgIdx = currentImgIdx - 1
        if currentImgIdx < 1 then
            currentImgIdx = #mainImgs
        end
        mainSprite:setImage(mainImgs[currentImgIdx])
    end
end
