# Miku on Playdate

# Random notes
- The playdate is a 2.7" 400x240 pixel screen with a 1-bit black and white display.
- The playdate has a 1-bit display, which means that each pixel can be either on or off, with no grayscale or color

# Dev notes
- music:setrate(x) to change the playback rate of a sound. 
- music:play(x,y) to play a sound. x is loop, y is the playback rate
- music:stop() to stop a sound

The playback speed is computed as
pbSpd = crankSpd / targetSpd 
so that when the measured speed equals the target, the rate is 1. When faster 1+x and when slower 1-x

so that when the measured speed equals the target, the rate is 1.


# Sources
- https://www.youtube.com/watch?v=UZ04rk3lLqU
- 

# Random notes

Crank Change: 28.8
Accelerated Change: 31.71389
Max Playback Speed: 3

playbackSpd = acceleratedChange / 360 * maxPlaybackSpd

Playback Speed: 0.2642824

--
