require "core"
require "objects"

SCREEN_SCALE = 3

function love.load()
    love.window.setTitle("Spelunky Classic LÖVE")
    love.window.setMode(320 * SCREEN_SCALE, 240 * SCREEN_SCALE)
    love.graphics.setDefaultFilter("nearest")

    canvas = love.graphics.newCanvas(320, 240)
end

function love.draw()
    love.graphics.setCanvas(canvas)

    love.graphics.clear(7/256, 12/256, 16/256, 1)
    core:draw()

    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, SCREEN_SCALE, SCREEN_SCALE)
end

function love.update(dt)
    core:update(dt * 30)
end
