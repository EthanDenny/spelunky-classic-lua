local Concord = require("concord")
local Sprites = require("sprites")

require("components")

local Block = {}

Block.assemble = function(e, x, y)
    e
    :give("sprite", Sprites.block)
    :give("pos", x, y)
    :give("size", 16, 16)
    :give("collider", {x=16, y=16})
    :give("solid")
end

Block.spawn = function(x, y)
    local e = Concord.entity(Core.world)
    return e:assemble(Block.assemble, x, y)
end

return Block
