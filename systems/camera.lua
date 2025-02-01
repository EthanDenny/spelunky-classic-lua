local Concord = require("Concord")
local Core = require("core")

require("components")

Camera = {
    x = 0,
    y = 0
}

local CameraSystem = Concord.system({
    pool = {"player"},
})

LERP_FACTOR = 0.175

function CameraSystem:update(delta)
    for _, player in ipairs(self.pool) do
        Camera.x = Core.lerp(Camera.x, math.min(math.max(player.pos.x - 160, 0), 352), LERP_FACTOR)
        Camera.y = Core.lerp(Camera.y, math.min(math.max(player.pos.y - 120, 0), 304), LERP_FACTOR)
    end
end

Core.world:addSystem(CameraSystem)
