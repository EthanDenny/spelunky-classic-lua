local Concord = require("concord")
local Core = require("core")

Concord.component("vel", function(c, x, y, limit)
    c.x = x or 0
    c.y = y or 0
    c.limit = limit
end)

Concord.component("acc", function(c, x, y, limit)
    c.x = x or 0
    c.y = y or 0
    c.limit = limit
end)

Concord.component("fric", function(c, x, y)
    c.x = x or 1
    c.y = y or 1
end)

local PhysicSystem = Concord.system({
    pool = {"pos", "vel"},
    colPool = {"pos", "collider", "solid"}
})

function PhysicSystem:update(delta)
    for _, e in ipairs(self.pool) do
        if e.acc then
            if e.acc.limit then
                e.acc.x = Core.clamp(e.acc.x, e.acc.limit.x)
                e.acc.y = Core.clamp(e.acc.y, e.acc.limit.y)
            end

            e.vel.x = e.vel.x + e.acc.x
            e.vel.y = e.vel.y + e.acc.y

            e.acc.x = 0
            e.acc.y = 0
        end
        
        if e.fric then
            e.vel.x = e.vel.x * e.fric.x
            e.vel.y = e.vel.y * e.fric.y
        end
        
        e.acc.x = 0
        e.acc.y = 0

        if e.vel and e.vel.limit then
            e.vel.x = Core.clamp(e.vel.x, e.vel.limit.x)
            e.vel.y = Core.clamp(e.vel.y, e.vel.limit.y)
        end
        
        if Core.approximatelyZero(e.vel.x) then e.vel.x = 0 end
        if Core.approximatelyZero(e.vel.y) then e.vel.y = 0 end
        
        move(e, self.colPool, delta)
    end
end

function move(e, pool, delta)
    e.pos.x = e.pos.x + e.vel.x * delta

    if e.collider then
        col = Collisions.colliding(e, pool)
        
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
        col = Collisions.colliding(e, pool)
        
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

return PhysicSystem
