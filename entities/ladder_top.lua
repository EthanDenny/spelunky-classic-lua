local Concord = require("concord")
local Sprites = require("sprites")

require("components")

local LadderTop = {}

LadderTop.assemble = function(e, x, y)
    e
    :give("sprite", Sprites.ladderTop)
    :give("pos", x, y)
    :give("size", 16, 16)
    :give("collider", {x=16, y=16})
    :give("ladder")
    :give("walkable")
end

LadderTop.spawn = function(x, y)
    local e = Concord.entity(Core.world)
    return e:assemble(LadderTop.assemble, x, y)
end

return LadderTop
