local Concord = require("concord")
local Sprites = require("sprites")

require("components")

local Spikes = {}

Spikes.assemble = function(e, x, y)
    e
    :give("sprite", Sprites.spikes)
    :give("pos", x, y)
    :give("size", 16, 16)
    :give("collider", {x=16, y=16})
    :give("solid")
    :give("spikes")
end

Spikes.spawn = function(x, y)
    local e = Concord.entity(Core.world)
    return e:assemble(Spikes.assemble, x, y)
end

return Spikes
