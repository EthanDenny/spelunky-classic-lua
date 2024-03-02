local Concord = require("concord")
local Sprites = require("sprites")

require("components")

local Ladder = {}

Ladder.assemble = function(e, x, y)
    e
    :give("sprite", Sprites.ladder)
    :give("pos", x, y)
    :give("size", 16, 16)
    :give("collider", {x=16, y=16})
    :give("ladder")
end

Ladder.spawn = function(x, y)
    local e = Concord.entity(Core.world)
    return e:assemble(Ladder.assemble, x, y)
end

return Ladder
