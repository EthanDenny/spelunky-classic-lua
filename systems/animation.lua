local Concord = require("concord")
local Sprites = require("sprites")

require("components")

local PlayerAnimSystem = Concord.system({
    pool = {"player"},
})

function PlayerAnimSystem:update(delta)
    for _, e in ipairs(self.pool) do
        if e:has("onGround") then
            if e:has("ducking") then
                e.animatedSprite.speed = 0.8
            else
                e.animatedSprite.speed = (math.abs(e.vel.x) + 1) / 10
            end
        end

        if math.abs(e.vel.x) >= 4 then
            e.animatedSprite.speed = 1
            if e:has("onGround") then
                e.collider.size.x = 16
                e.collider.offset.x = 0
            else
                e.collider.size.x = 10
                e.collider.offset.x = 3
            end
        else
            e.collider.size.x = 10
            e.collider.offset.x = 3
        end

        if e.animatedSprite.speed > 1 then
            e.animatedSprite.speed = 1
        end

        if e:has("lookingUp") then
            if e.vel.x == 0 then
                PlayerAnimSystem:changeAnimation(e, Sprites.playerLook, 1)
            else
                PlayerAnimSystem:changeAnimation(e, Sprites.playerLookRun, 6)
            end
        elseif e:has("ducking") then
            if e.vel.x == 0 then
                PlayerAnimSystem:changeAnimation(e, Sprites.playerDuck, 1)
            else
                PlayerAnimSystem:changeAnimation(e, Sprites.playerCrawl, 10)
            end
        elseif not e:has("onGround") then
            if e:has("hanging") then
                PlayerAnimSystem:changeAnimation(e, Sprites.playerHang, 1)
            elseif e:has("jumping") then
                PlayerAnimSystem:changeAnimation(e, Sprites.playerJump, 1)
            else
                PlayerAnimSystem:changeAnimation(e, Sprites.playerFall, 1)
            end
        else
            if e.vel.x == 0 then
                PlayerAnimSystem:changeAnimation(e, Sprites.playerStand, 1)
            else
                PlayerAnimSystem:changeAnimation(e, Sprites.playerRun, 6)
            end
        end
    end
end

function PlayerAnimSystem:changeAnimation(e, sheet, frames)
    if sheet ~= e.animatedSprite.sheet then
        local speed = e.animatedSprite.speed

        e
        :remove("animatedSprite")
        :give("animatedSprite", sheet, frames, speed)

        e.animatedSprite.frameNumber = 0
    end
end

Core.world:addSystems(PlayerAnimSystem)
