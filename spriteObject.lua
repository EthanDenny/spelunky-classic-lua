local Concord = require("concord")
local Core = require("core")

Concord.component("sprite", function(c, sheet, frameCount)
    c.sheet = sheet
end)

Concord.component("animatedSprite", function(c, sheet, frameCount, speed)
    c.sheet = sheet
    c.frameCount = frameCount or 1
    c.frameWidth = sheet:getWidth() / frameCount
    c.frameHeight = sheet:getHeight()
    c.frameQuad = love.graphics.newQuad(
        0,
        0,
        c.frameWidth,
        c.frameHeight,
        sheet
    )
    c.speed = speed or 1
    c.frameNumber = 0
    c.frameTimer = 0
end)

Concord.component("orientation", function(c, flipped, mirrored)
    c.rotation = rotation or 0
    c.flipped = flipped or false
    c.mirrored = mirrored or false
end)

local DrawSystem = Concord.system({
    fullPool = {"sprite", "animatedSprite", "pos", "size"},
    spritePool = {"sprite", "pos", "size"},
    animatedPool = {"animatedSprite", "pos", "size"}
})

function DrawSystem:update(delta)
    for _, e in ipairs(self.animatedPool) do
        local s = e.animatedSprite

        -- FPS = 1 / speed; e.g. 0.4 = 12 FPS, 1 = 30 FPS
        local frameDuration = 1 / s.speed

        s.frameTimer = s.frameTimer + delta

        if s.frameTimer >= frameDuration then
            s.frameTimer = s.frameTimer - frameDuration

            s.frameNumber = s.frameNumber + 1
            if s.frameNumber >= s.frameCount then
                s.frameNumber = 0
            end

            s.frameQuad = love.graphics.newQuad(
                s.frameNumber * s.frameWidth,
                0,
                s.frameWidth,
                s.frameHeight,
                s.sheet
            )
        end
    end
end

function DrawSystem:draw()
    for _, e in ipairs(self.spritePool) do
        if e.orientation then
            love.graphics.draw(
                e.sprite.sheet,
                math.floor(e.pos.x + 0.5),
                math.floor(e.pos.y + 0.5),
                e.orientation.rotation,
                e.orientation.mirrored and -1 or 1,
                e.orientation.flipped and -1 or 1,
                e.size.x / 2,
                e.size.y / 2
            )
        else
            love.graphics.draw(
                e.sprite.sheet,
                math.floor(e.pos.x + 0.5),
                math.floor(e.pos.y + 0.5),
                0,
                1,
                1,
                e.size.x / 2,
                e.size.y / 2
            )
        end
    end

    for _, e in ipairs(self.animatedPool) do
        love.graphics.draw(
            e.animatedSprite.sheet,
            e.animatedSprite.frameQuad,
            math.floor(e.pos.x + 0.5),
            math.floor(e.pos.y + 0.5),
            e.orientation.rotation,
            e.orientation.mirrored and -1 or 1,
            e.orientation.flipped and -1 or 1,
            e.size.x / 2,
            e.size.y / 2
        )

        if e.orientation then
            love.graphics.draw(
                e.animatedSprite.sheet,
                e.animatedSprite.frameQuad,
                math.floor(e.pos.x + 0.5),
                math.floor(e.pos.y + 0.5),
                e.orientation.rotation,
                e.orientation.mirrored and -1 or 1,
                e.orientation.flipped and -1 or 1,
                e.size.x / 2,
                e.size.y / 2
            )
        else
            love.graphics.draw(
                e.animatedSprite.sheet,
                e.animatedSprite.frameQuad,
                math.floor(e.pos.x + 0.5),
                math.floor(e.pos.y + 0.5),
                0,
                1,
                1,
                e.size.x / 2,
                e.size.y / 2
            )
        end
    end
end

return DrawSystem
