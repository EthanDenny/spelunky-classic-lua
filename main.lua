local Core = require("core")
local Entities = require("entities")

require("systems")

SCREEN_SCALE = 3

Canvas = nil
BGImage = nil
BGQuad = nil

-- Pretty basic stuff, no ECS here
function love.load()
    love.window.setTitle("Spelunky Classic LÖVE")
    love.window.setMode(320 * SCREEN_SCALE, 240 * SCREEN_SCALE)
    love.graphics.setDefaultFilter("nearest", "nearest")
    Canvas = love.graphics.newCanvas(320, 240)

    BGImage = love.graphics.newImage("sprites/CaveBackground.png")
    BGImage:setWrap("repeat", "repeat")
    BGQuad = love.graphics.newQuad(0, 0, 320 * SCREEN_SCALE, 240 * SCREEN_SCALE, BGImage:getWidth(), BGImage:getHeight())

    Entities.player.spawn()

    Entities.spider.spawn()
    Entities.spider.spawn()
    Entities.spider.spawn()

    Entities.block.spawn(152, 184)
    Entities.block.spawn(152, 184 - 16)
    Entities.block.spawn(152 + 16, 184)
    Entities.block.spawn(152 + 16, 184 - 16)
    Entities.block.spawn(152 + 16, 184 - 32)
    Entities.block.spawn(152 + 16, 184 - 48)
    Entities.block.spawn(152 + 48, 184)
    Entities.block.spawn(152 + 48, 184 - 16)

    for x = 0, 19 do
        for _, y in ipairs({12, 13, 14}) do
            Entities.block.spawn(x * 16 + 8, y * 16 + 8)
        end
    end
end

-- Standard stuff again
function love.draw()
    love.graphics.setCanvas(Canvas)

    love.graphics.draw(BGImage, BGQuad, 0, 0)

    Core.world:emit("draw")

    love.graphics.setCanvas()
    love.graphics.draw(Canvas, 0, 0, 0, SCREEN_SCALE, SCREEN_SCALE)
end

-- Multiplying by 30 so that the physics code I adapted works much more nicely
function love.update(dt)
    Core.world:emit("update", dt * 30)
end
