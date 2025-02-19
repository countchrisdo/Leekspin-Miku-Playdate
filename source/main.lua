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
local targetPlaybackSpd = 1
local minPlaybackSpd = -3
local maxPlaybackSpd = 3
music:play(0,playbackSpd) -- loop forever, 0% playback speed

-- Game State
local crankSpd = 0
local targetCrankSpd = 25 -- DPF: Degrees Per Frame
local TPR = 6 -- TPR: Ticks per Revolution
local currentImgIdx = 1
local bufferedFrames = 15
local crankBuffer = {}

-- Functions
local function getAverageSpd(newSpd)
    table.insert(crankBuffer, newSpd)
    if #crankBuffer > bufferedFrames then
        table.remove(crankBuffer, 1)
    end

    local sum = 0
    for i = 1, #crankBuffer do
        sum = sum + crankBuffer[i]
    end
    return sum / #crankBuffer
end

-- Update
-- -- Runs every frame / PD runs 30fps
function pd.update()
    gfx.sprite.update()

    local crankChange, acceleratedChange = pd.getCrankChange()
    -- maximum crankChange is 72 degrees per frame
    crankSpd = getAverageSpd(crankChange)

    -- set playback speed based on ratio of crankSpd to targetCrankSpd
    print("Crankspd: " .. crankSpd)
    print("Target Crank Spd: " .. targetCrankSpd)
    playbackSpd = crankSpd / targetCrankSpd 
    print("Initial Playback Speed: " .. playbackSpd)

    -- Assist keeping playbackSpd at targetPlaybackSpd
    if math.abs(playbackSpd - targetPlaybackSpd) <= 0.2 then
        print("Playback Speed is close to target, setting to target")
        playbackSpd = targetPlaybackSpd
    end

    -- Clamp pbSpd
    if playbackSpd > maxPlaybackSpd then
        playbackSpd = maxPlaybackSpd
        print("Max Playback Speed Reached")
    elseif playbackSpd < -maxPlaybackSpd then
        playbackSpd = -maxPlaybackSpd
    end

    print("Final Playback Speed: " .. playbackSpd)
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
