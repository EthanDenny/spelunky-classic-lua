-- Most of this file is nitpicky movement stuff
-- move() is probably the only interesting function
-- I wish I had a better way to do collisions in it

local Concord = require("Concord")
local Core = require("core")
require("components")

local PhysicSystem = Concord.system({
    pool = {"pos", "vel"},
    accPool = {"pos", "vel", "acc"},
    fricPool = {"pos", "vel", "fric"},
    colPool = {"pos", "collider", "solid"}
})

function PhysicSystem:update(delta)
    for _, e in ipairs(self.accPool) do
        if e.acc.limit then
            e.acc.x = Core.clamp(e.acc.x, e.acc.limit.x)
            e.acc.y = Core.clamp(e.acc.y, e.acc.limit.y)
        end

        e.vel.x = e.vel.x + e.acc.x
        e.vel.y = e.vel.y + e.acc.y

        e.acc.x = 0
        e.acc.y = 0
    end

    for _, e in ipairs(self.fricPool) do
        e.vel.x = e.vel.x * e.fric.x
        e.vel.y = e.vel.y * e.fric.y
    end

    for _, e in ipairs(self.pool) do
        if e.vel.limit then
            e.vel.x = Core.clamp(e.vel.x, e.vel.limit.x)
            e.vel.y = Core.clamp(e.vel.y, e.vel.limit.y)
        end

        if Core.approximatelyZero(e.vel.x) then e.vel.x = 0 end
        if Core.approximatelyZero(e.vel.y) then e.vel.y = 0 end

        PhysicSystem:move(e, self.colPool, delta)
    end
end

function PhysicSystem:move(e, pool, delta)
    e.pos.x = e.pos.x + e.vel.x * delta

    if e.collider then
        local col = Collisions.colliding(e, pool)

        while col ~= nil do
            if e.vel.x < 0 then
                e.pos.x = col.pos.x + col.collider.offset.x + col.collider.size.x - e.collider.offset.x
            elseif e.vel.x > 0 then
                e.pos.x = col.pos.x - e.collider.offset.x - e.collider.size.x
            end

            col = Collisions.colliding(e, pool)
        end
    end

    e.pos.y = e.pos.y + e.vel.y * delta

    if e.collider then
        local col = Collisions.colliding(e, pool)

        while col ~= nil do
            if e.vel.y < 0 then
                e.pos.y = col.pos.y + col.collider.offset.y + col.collider.size.y - e.collider.offset.y
            elseif e.vel.y > 0 then
                e.pos.y = col.pos.y - e.collider.offset.y - e.collider.size.y
            end

            col = Collisions.colliding(e, pool)
        end
    end
end

Core.world:addSystem(PhysicSystem)
