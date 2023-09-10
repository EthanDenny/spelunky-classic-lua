local Concord = require("concord")
local Core = require("core")
local Sprites = require("sprites")

require("components")

Player = {}

Player.assemble = function(e, x, y)
    e
    :give("player")
    :give("animatedSprite", Sprites.playerRun, 6, 0.4)
    :give("pos", x, y)
    :give("size", 16, 16)
    :give("orientation")
    :give("collider", {x=10, y=16}, {x=3, y=0})
    :give("vel", 0, 0, {x=16, y=10})
    :give("acc", 0, 0, {x=9, y=6})
    :give("fric")
    :give("playerInputs")
    :give("playerPhysics")
end

Player.spawn = function(x, y)
    local e = Concord.entity(Core.world)
    return e:assemble(Player.assemble, x, y)
end

return Player
