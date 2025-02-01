local Concord = require("Concord")
local Sprites = require("sprites")

require("components")

local Brick = {}

Brick.assemble = function(e, x, y)
    e
    :give("sprite", Sprites.brick)
    :give("pos", x, y)
    :give("size", 16, 16)
    :give("collider", {x=16, y=16})
    :give("solid")
end

Brick.spawn = function(x, y)
    local e = Concord.entity(Core.world)
    return e:assemble(Brick.assemble, x, y)
end

return Brick
