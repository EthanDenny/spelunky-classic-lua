local Concord = require("concord")

local sLookLeft = love.graphics.newImage("sprites/PlayerLook.png")
local sLookRun = love.graphics.newImage("sprites/PlayerLookRun.png")
local sDuckLeft = love.graphics.newImage("sprites/PlayerDuck.png")
local sCrawlLeft = love.graphics.newImage("sprites/PlayerCrawl.png")
local sHangLeft = love.graphics.newImage("sprites/PlayerHang.png")
local sJumpLeft = love.graphics.newImage("sprites/PlayerJump.png")
local sFallLeft = love.graphics.newImage("sprites/PlayerFall.png")
local sStandLeft = love.graphics.newImage("sprites/PlayerStand.png")
local sRunLeft = love.graphics.newImage("sprites/PlayerRun.png")

local runAnimSpeed = 0.1

local PlayerAnimSystem = Concord.system({
    pool = {"pState"},
})

function PlayerAnimSystem:update(delta)
    for _, e in ipairs(self.pool) do
        if e.pState.onGround and not e.pState.ducking then
            e.animatedSprite.speed = math.abs(e.vel.x) * runAnimSpeed + 0.1
        end

        if math.abs(e.vel.x) >= 4 then
            e.animatedSprite.speed = 1
            if e.pState.onGround then
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

        if e.animatedSprite.speed > 1 then e.animatedSprite.speed = 1 end

        oldSheet = e.animatedSprite.sheet

        if e.pState.lookingUp then
            if e.vel.x == 0 then
                PlayerAnimSystem:changeAnimation(e, sLookLeft, 1)
            else
                PlayerAnimSystem:changeAnimation(e, sLookRun, 6)
            end
        elseif e.pState.ducking then
            if e.vel.x == 0 then
                PlayerAnimSystem:changeAnimation(e, sDuckLeft, 1)
            else
                PlayerAnimSystem:changeAnimation(e, sCrawlLeft, 10)
            end
        elseif not e.pState.onGround then
            if e.pState.hanging then
                PlayerAnimSystem:changeAnimation(e, sHangLeft, 1)
            elseif e.pState.jumping then
                PlayerAnimSystem:changeAnimation(e, sJumpLeft, 1)
            else
                PlayerAnimSystem:changeAnimation(e, sFallLeft, 1)
            end
        else
            if e.vel.x == 0 then
                PlayerAnimSystem:changeAnimation(e, sStandLeft, 1)
            else
                PlayerAnimSystem:changeAnimation(e, sRunLeft, 6)
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

return PlayerAnimSystem
