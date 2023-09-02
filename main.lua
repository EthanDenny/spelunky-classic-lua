local Concord = require("concord")
local Core = require("core")

local PlayerSystem = require("player")
local PhysicSystem = require("physics")
local DrawSystem = require("draw")

require("block")

Core.world:addSystems(PlayerSystem, PhysicSystem, DrawSystem)

SCREEN_SCALE = 3

function love.load()
    love.window.setTitle("Spelunky Classic LÖVE")
    love.window.setMode(320 * SCREEN_SCALE, 240 * SCREEN_SCALE)
    love.graphics.setDefaultFilter("nearest")
    canvas = love.graphics.newCanvas(320, 240)

    bg_image = love.graphics.newImage("sprites/caveBackground.png")
    bg_image:setWrap("repeat", "repeat")
    bg_quad = love.graphics.newQuad(0, 0, 320 * SCREEN_SCALE, 240 * SCREEN_SCALE, bg_image:getWidth(), bg_image:getHeight())
end

function love.draw()
    love.graphics.setCanvas(canvas)
    
    love.graphics.draw(bg_image, bg_quad, 0, 0)

    Core.world:emit("draw")

    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, SCREEN_SCALE, SCREEN_SCALE)
end

function love.update(dt)
    Core.world:emit("update", dt * 30)
end
