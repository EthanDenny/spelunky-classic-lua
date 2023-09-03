local Concord = require("concord")
local Core = require("core")
local DrawSystem = require("draw")
local PhysicsSystem = require("physics")
local Player = require("player")

local sSpider = love.graphics.newImage("sprites/Spider.png")

function spiderAssemble(e, x, y)
    e
    :give("animatedSprite", sSpider, 4, 0.4)
    :give("pos", x, y)
    :give("size", 16, 16)
    :give("orientation")
    :give("collider", {x=14, y=11}, {x=1, y=5})
    :give("vel", 0, 0, {x=16, y=10})
    :give("fric")
    :give("spider")
end

Concord.component("spider", function(c)
    c.state = "IDLE"
    c.stateTimer = 0
    c.grav = 0.2
end)

local SpiderAISystem = Concord.system({
    pool = {"spider"},
    playerPool = {"pState"},
    colPool = {"pos", "collider", "solid"}
})

local spider = Concord.entity(Core.world)
spider:assemble(spiderAssemble, 50, 184)

local spider = Concord.entity(Core.world)
spider:assemble(spiderAssemble, 50, 184)

local spider = Concord.entity(Core.world)
spider:assemble(spiderAssemble, 50, 184)

function SpiderAISystem:update(delta)
    local player = nil

    for _, p in ipairs(self.playerPool) do
        player = p
    end

    for _, e in ipairs(self.pool) do
        e.spider.stateTimer = e.spider.stateTimer - delta
        e.vel.y = e.vel.y + e.spider.grav

        if e.spider.stateTimer <= 0 then
            e.spider.state = "BOUNCE"

            if Collisions.colBottom(e, self.colPool) then
                e.vel.y = -1 * math.random(2, 5)

                if player.pos.x < e.pos.x then
                    e.vel.x = -2.5
                else
                    e.vel.x = 2.5
                end
            end
        end

        if Collisions.colRight(e, self.colPool) then
            e.vel.x = 1
        end

        if Collisions.colLeft(e, self.colPool) then
            e.vel.x = -1
        end

        local dist = math.sqrt((player.pos.x - e.pos.x) ^ 2 +
                               (player.pos.y - e.pos.y) ^ 2)

        if e.spider.state == "IDLE" then
            e.spider.stateTimer = math.random(5, 20)
            e.spider.state = "RECOVER"
        elseif e.spider.state == "RECOVER" then
            if Collisions.colBottom(e, self.colPool) then
                e.vel.x = 0
            end
        elseif e.spider.state == "BOUNCE" and dist < 90 then
            if Collisions.colBottom(e, self.colPool) then
                e.vel.y = -1 * math.random(2, 5)

                if player.pos.x < e.pos.x + 8 then
                    e.vel.x = -2.5
                else
                    e.vel.x = 2.5
                end
                
                if math.random(1, 4) == 1 then
                    e.spider.state = "IDLE";
                    e.vel.x = 0
                    e.vel.y = 0
                end
            end
        elseif e.spider.state ~= "DROWNED" then
            e.spider.state = IDLE;
        end

        if Collisions.colTop(e, self.colPool) then
            e.vel.y = 1
        end
    end
end

return SpiderAISystem
