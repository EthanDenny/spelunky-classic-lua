local Concord = require("concord")
local Core = require("core")

Concord.component("sprite", function(c, sheet, frameCount)
    c.sheet = sheet
end)

Concord.component("animatedSprite", function(c, sheet, frameCount, speed)
    c.sheet = sheet
    c.frameCount = frameCount or 1
    c.frameQuad = love.graphics.newQuad(
        0,
        0,
        sheet:getWidth() / frameCount,
        sheet:getHeight(),
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
    spritePool = {"sprite", "pos", "size"},
    animatedPool = {"animatedSprite", "pos", "size"}
})

function DrawSystem:update(delta)
    for _, e in ipairs(self.animatedPool) do
        if e.animatedSprite then
            local frameWidth = e.animatedSprite.sheet:getWidth() / e.animatedSprite.frameCount
            local frameHeight = e.animatedSprite.sheet:getHeight()

            -- animatedSprite completes once per "e.sprite.speed" seconds
            local frameDuration = 1 / e.animatedSprite.speed

            e.animatedSprite.frameTimer = e.animatedSprite.frameTimer + delta

            if e.animatedSprite.frameTimer >= frameDuration then
                e.animatedSprite.frameTimer = e.animatedSprite.frameTimer - frameDuration

                e.animatedSprite.frameNumber = e.animatedSprite.frameNumber + 1
                if e.animatedSprite.frameNumber >= e.animatedSprite.frameCount then
                    e.animatedSprite.frameNumber = 0
                end

                e.animatedSprite.frameQuad = love.graphics.newQuad(
                    e.animatedSprite.frameNumber * frameWidth,
                    0,
                    frameWidth,
                    frameHeight,
                    e.animatedSprite.sheet
                )
            end
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
    end
end

return DrawSystem
