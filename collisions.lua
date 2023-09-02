local Concord = require("concord")

-- Components

Concord.component("collider", function(c, size, offset)
    c.size = size or {x=0, y=0}
    c.offset = offset or {x=0, y=0}
end)

Concord.component("solid")

Collisions = {}

--[[
    Given an entity and a pool of objects, determine if the entity is colliding
    with any of the objects in the pool
]]--

function Collisions.colliding(e1, pool)
    for _, e2 in ipairs(pool) do
        local e1RealColPos = {
            x = e1.pos.x - e1.size.x / 2 + e1.collider.offset.x,
            y = e1.pos.y - e1.size.y / 2 + e1.collider.offset.y
        }

        local e2RealColPos = {
            x = e2.pos.x - e2.size.x / 2 + e2.collider.offset.x,
            y = e2.pos.y - e2.size.y / 2 + e2.collider.offset.y
        }

        if (e1 ~= e2 and
            e1RealColPos.x < e2RealColPos.x + e2.collider.size.x and
            e1RealColPos.y < e2RealColPos.y + e2.collider.size.y and
            e1RealColPos.x + e1.collider.size.x > e2RealColPos.x and
            e1RealColPos.y + e1.collider.size.y > e2RealColPos.y) then
            return e2
        end
    end

    return nil
end

--[[
    Given an entity, a pool of objects, and an amount, determine if moving the
    entity by amount pixels in the given direction would result in a collision
    with any of the objects in the pool
]]--

function Collisions.colLeft(e, pool, amount)
    amount = amount or 1
    e.pos.x = e.pos.x - amount
    col = Collisions.colliding(e, pool)
    e.pos.x = e.pos.x + amount
    return col ~= nil
end

function Collisions.colRight(e, pool, amount)
    amount = amount or 1
    e.pos.x = e.pos.x + amount
    col = Collisions.colliding(e, pool)
    e.pos.x = e.pos.x - amount
    return col ~= nil
end

function Collisions.colTop(e, pool, amount)
    amount = amount or 1
    e.pos.y = e.pos.y - amount
    col = Collisions.colliding(e, pool)
    e.pos.y = e.pos.y + amount
    return col ~= nil
end

function Collisions.colBottom(e, pool, amount)
    amount = amount or 1
    e.pos.y = e.pos.y + amount
    col = Collisions.colliding(e, pool)
    e.pos.y = e.pos.y - amount
    return col ~= nil
end

return Collisions
