local Core = require("core")
local WorldGenerator = require("world_generator")

require("systems")

math.randomseed(os.time())

SCREEN_SCALE = 3

Canvas = nil
BGImage = nil
BGQuad = nil

-- Pretty basic stuff, no ECS here
function love.load()
    love.window.setTitle("Spelunky Classic LÖVE")
    love.window.setMode(320 * SCREEN_SCALE, 240 * SCREEN_SCALE)
    love.graphics.setDefaultFilter("nearest", "nearest")
    Canvas = love.graphics.newCanvas(672, 544)

    BGImage = love.graphics.newImage("sprites/CaveBackground.png")
    BGImage:setWrap("repeat", "repeat")
    BGQuad = love.graphics.newQuad(0, 0, 672, 544, BGImage:getWidth(), BGImage:getHeight())

    WorldGenerator.createLevel()
end

-- Standard stuff again
function love.draw()
    love.graphics.setCanvas(Canvas)

    love.graphics.draw(BGImage, BGQuad, 0, 0)

    Core.world:emit("draw")

    love.graphics.setCanvas()
    love.graphics.draw(Canvas, Core.round(-Camera.x * SCREEN_SCALE), Core.round(-Camera.y * SCREEN_SCALE), 0, SCREEN_SCALE, SCREEN_SCALE)
end

-- Multiplying by 30 so that the physics code I adapted works much more nicely
function love.update(dt)
    Core.world:emit("update", dt * 30)
end
