-- We be drawing pixels baby
-- Nothing super crazy here

local Concord = require("Concord")
local Core = require("core")

require("components")

local DrawSystem = Concord.system({
    fullPool = {"sprite", "animatedSprite", "pos", "size"},
    spritePool = {"sprite", "pos", "size"},
    animatedPool = {"animatedSprite", "pos", "size"},
    colPool = {"pos", "collider"},
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
                Core.round(e.pos.x),
                Core.round(e.pos.y),
                e.orientation.rotation,
                e.orientation.mirrored and -1 or 1,
                e.orientation.flipped and -1 or 1,
                e.size.x / 2,
                e.size.y / 2
            )
        else
            love.graphics.draw(
                e.sprite.sheet,
                Core.round(e.pos.x),
                Core.round(e.pos.y),
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
            Core.round(e.pos.x),
            Core.round(e.pos.y),
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
                Core.round(e.pos.x),
                Core.round(e.pos.y),
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
                Core.round(e.pos.x),
                Core.round(e.pos.y),
                0,
                1,
                1,
                e.size.x / 2,
                e.size.y / 2
            )
        end
        
        --[[
            DrawSystem:drawTestPoint(e.pos.x + 9, e.pos.y - 5, self.colPool, false)
            DrawSystem:drawTestPoint(e.pos.x - 9, e.pos.y - 5, self.colPool, false)

            DrawSystem:drawTestPoint(e.pos.x + 9, e.pos.y - 6, self.colPool, false)
            DrawSystem:drawTestPoint(e.pos.x - 9, e.pos.y - 6, self.colPool, false)

            DrawSystem:drawTestPoint(e.pos.x + 9, e.pos.y - 9, self.colPool, true)
            DrawSystem:drawTestPoint(e.pos.x - 9, e.pos.y - 9, self.colPool, true)

            DrawSystem:drawTestPoint(e.pos.x, e.pos.y + 9, self.colPool, true)
        ]]
    end

    for _, e in ipairs(self.colPool) do
        local show_collision_rectangles = false

        if show_collision_rectangles then
            love.graphics.rectangle(
                "fill",
                Core.round(e.pos.x) - e.size.x / 2 + e.collider.offset.x,
                Core.round(e.pos.y) - e.size.y / 2 + e.collider.offset.y,
                e.collider.size.x,
                e.collider.size.y
            )
        end
    end
end

function DrawSystem.drawTestPoint(x, y, pool, invert)
    if Collisions.colPoint(x, y, pool) then
        if invert then
            love.graphics.setColor(0, 0, 1)
        else
            love.graphics.setColor(0, 1, 0)
        end
    else
        love.graphics.setColor(1, 0, 0)
    end

    love.graphics.points(x, y)

    love.graphics.setColor(1, 1, 1)
end

Core.world:addSystem(DrawSystem)
