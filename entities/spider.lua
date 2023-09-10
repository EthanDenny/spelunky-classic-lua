local Concord = require("concord")
local Core = require("core")
local Sprites = require("sprites")

require("components")

local Spider = {}

Spider.assemble = function(e, x, y)
    e
    :give("animatedSprite", Sprites.spider, 4, 0.4)
    :give("pos", x, y)
    :give("size", 16, 16)
    :give("orientation")
    :give("collider", {x=14, y=11}, {x=1, y=5})
    :give("vel", 0, 0, {x=16, y=10})
    :give("fric")
    :give("spider")
end

Spider.spawn = function(x, y)
    local e = Concord.entity(Core.world)
    return e:assemble(Spider.assemble, x or 50, y or 184)
end

return Spider
