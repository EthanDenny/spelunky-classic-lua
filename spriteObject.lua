local Concord = require("concord")
local Core = require("core")

Concord.component("sprite", function(c, image)
    c.image = image
end)

Concord.component("orientation", function(c, flipped, mirrored)
    c.rotation = rotation or 0
    c.flipped = flipped or false
    c.mirrored = mirrored or false
end)

function spriteObjectAssemble(e, sprite, x, y, width, height, rot, flip, mirror)
    e
    :give("sprite", sprite)
    :give("pos", x, y)
    :give("size", width, height)
    :give("orientation", rot, flip, mirror)
end

local DrawSystem = Concord.system({
    pool = {"sprite", "pos", "size"}
})

function DrawSystem:draw()
    for _, e in ipairs(self.pool) do
        love.graphics.draw(
            e.sprite.image,
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

Core.world:addSystem(DrawSystem)

return spriteObjectAssemble
