local Concord = require("concord")

Core = {}
Core.world = Concord.world()

-- Helper functions

function Core.approximatelyZero(value)
    return math.abs(value) < 0.1
end

function Core.clamp(value, bound)
    if value > bound then
        return bound
    elseif value < -bound then
        return -bound
    else
        return value
    end
end

function Core.round(v)
    return math.floor(v + 0.5)
end

function Core.lerp(a, b, t)
    return a * (1 - t) + b * t
end

function Core.choose(...)
    return select(math.random(select("#", ...)), ...)
end

-- Return

return Core
