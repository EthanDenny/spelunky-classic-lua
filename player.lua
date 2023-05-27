local Concord = require("concord")
local Collisions = require("collisions")
local spriteObjectAssemble = require("spriteObject")
local keybinds = require("keybindings")
require("physics")

-- Inputs

local kLeftReleased = false
local kLeft = false
local kRightReleased = false
local kRight = false

local kRun = false
local kAttack = false
local kUp = false
local kDown = false

local kItemPressed = false
local kItem = false

local kJumpPressed = false
local kJumpReleased = false
local kJump = false

local kLeftPushedSteps = 0
local kRightPushedSteps = 0

function love.keypressed(key, scancode)
    if scancode == keybinds.jump then kJumpPressed = true end
    if scancode == keybinds.item then kItemPressed = true end
end

function love.keyreleased(key, scancode)
    if scancode == keybinds.left then kLeftReleased = true end
    if scancode == keybinds.right then kRightReleased = true end
    if scancode == keybinds.jump then kJumpReleased = true end
end

function resetKeyPresses()
    kLeftReleased = false
    kRightReleased = false
    kJumpPressed = false
    kJumpReleased = false
    kItemPressed = false
end

-- Physics

local grav = 1
local gravNorm = 1
local gravityIntensity = grav

local runAcc = 3

local initialJumpAcc = -2
local jumpTimeTotal = 10
local jumpTime = jumpTimeTotal

local frictionRunningX = 0.6
local frictionRunningFastX = 0.98

-- Player

Concord.component("playerState", function(c)
    c.ducking = false
    c.lookingUp = false

    c.onGround = false
    c.climbing = false
    c.jumping = false

    c.duckingToHang = false
    c.hanging = false
end)

local playerSprite = love.graphics.newImage("sprites/playerStand.png")

function playerAssemble(e, x, y)
    e
    :assemble(spriteObjectAssemble, playerSprite, x, y, 16, 16)
    :give("collider", {x=10, y=16}, {x=3, y=0})
    :give("vel", 1, 0, {x=16, y=10})
    :give("acc", 0, 0, {x=9, y=6})
    :give("fric")
    :give("playerState")
end

local PlayerSystem = Concord.system({
    pool = {"playerState"},
    colPool = {"pos", "collider", "solid"}
})

function PlayerSystem:update(delta)
    for _, e in ipairs(self.pool) do
        -- Get inputs

        kLeft = love.keyboard.isDown(keybinds.left)
        kRight = love.keyboard.isDown(keybinds.right)
        kUp = love.keyboard.isDown(keybinds.up)
        kDown = love.keyboard.isDown(keybinds.down)

        kRun = love.keyboard.isDown(keybinds.run)
        kJump = love.keyboard.isDown(keybinds.jump)
        kAttack = love.keyboard.isDown(keybinds.attack)

        if kLeft then
            kLeftPushedSteps = kLeftPushedSteps + delta
        else
            kLeftPushedSteps = 0
        end
            
        if kRight then
            kRightPushedSteps = kRightPushedSteps + delta
        else
            kRightPushedSteps = 0
        end

        if kRun then
            runHeld = 100
        end
        
        if kAttack then
            runHeld = runHeld + delta
        end

        if not kRun or (not kLeft and not kRight) then
            runHeld = 0
        end

        -- Walking

        if not e.playerState.climbing and not e.playerState.hanging then
            if kLeftReleased and Core.approximatelyZero(e.vel.x) then e.acc.x = e.acc.x - 0.5 end
            if kRightReleased and Core.approximatelyZero(e.vel.x) then e.acc.x = e.acc.x + 0.5 end

            if kLeft and not kRight then
                if kLeftPushedSteps > 2 and (not e.orientation.mirrored or Core.approximatelyZero(e.vel.x)) then
                    e.acc.x = e.acc.x - runAcc
                end
                e.orientation.mirrored = false
            end
        
            if kRight and not kLeft then
                if kRightPushedSteps > 2 and (e.orientation.mirrored or Core.approximatelyZero(e.vel.x)) then
                    e.acc.x = e.acc.x + runAcc
                end
                e.orientation.mirrored = true
            end
        end

        if Collisions.colBottom(e, self.colPool) and not kJump and not kDown and not kRun then
            e.vel.limit.x = 3
        end

        -- Bouncing off solids

        if Collisions.colTop(e, self.colPool) then
            if dead or stunned then
                e.vel.y = -e.vel.y * 0.8
            elseif not e.playerState.onGround and e.playerState.jumping then
                e.vel.y = math.abs(e.vel.y * 0.3)
            end
        end

        if (Collisions.colLeft(e, self.colPool) and not e.orientation.mirrored) or (Collisions.colRight(e, self.colPool) and e.orientation.mirrored) then
            if dead or stunned then
                e.vel.x = -e.vel.x * 0.5
            else
                e.vel.x = 0
            end
        end

        -- Jumping

        if not e.playerState.onGround and not e.playerState.hanging then
            e.acc.y = e.acc.y + gravityIntensity * delta
        end

        if Collisions.colBottom(e, self.colPool) then
            e.playerState.onGround = true
            e.vel.y = 0
            e.acc.y = 0
        end

        if not Collisions.colBottom(e, self.colPool) and e.playerState.onGround then
            e.playerState.onGround = false
            e.playerState.jumping = false
            e.acc.y = e.acc.y + grav * delta
        end

        if e.playerState.onGround and kJumpPressed then
            if math.abs(e.vel.x) > 3 then
                e.acc.x = e.acc.x + e.vel.x * 2
            else
                e.acc.x = e.acc.x + e.vel.x / 2
            end

            e.acc.y = e.acc.y + initialJumpAcc * 2

            e.acc.limit.y = 6
            grav = gravNorm

            e.playerState.onGround = false

            jumpTime = 0
        end

        if jumpTime < jumpTimeTotal then
            jumpTime = jumpTime + delta
        end

        if kJumpReleased then
            jumpTime = jumpTimeTotal
        end

        gravityIntensity = (jumpTime / jumpTimeTotal) * grav

        -- Changing states

        e.playerState.lookingUp = kUp and e.playerState.onGround

        if kDown then
            e.playerState.ducking = e.playerState.onGround
        elseif e.playerState.ducking then
            e.playerState.ducking = false
            e.vel.x = 0
            e.acc.x = 0
        end

        if e.vel.y < 0 and not e.playerState.onGround and not e.playerState.hanging then
            e.playerState.jumping = true
        end

        if e.vel.y > 0 and not e.playerState.onGround and not e.playerState.hanging then
            e.playerState.jumping = true
            e.collider.size.y = 14
            e.collider.offset.y = 2
        else
            e.collider.size.y = 16
            e.collider.offset.y = 0
        end

        -- Calculate friction

        if not e.playerState.climbing then
            if kRun and e.playerState.onGround and runHeld >= 10 then
                if kLeft then
                    e.vel.x = e.vel.x - delta * 0.1
                    e.vel.limit.x = 6
                    e.fric.x = frictionRunningFastX
                elseif kRight then
                    e.vel.x = e.vel.x + delta * 0.1
                    e.vel.limit.x = 6
                    e.fric.x = frictionRunningFastX
                end
            elseif e.playerState.ducking then
                e.fric.x = 0.2
                e.vel.limit.x = 3
                image_speed = 0.8

                if math.abs(e.vel.x) >= 2 then
                    e.vel.x = e.vel.x * 0.8
                end
            else
                if not e.playerState.onGround then
                    if dead or stunned then
                        e.fric.x = 1.0
                    else
                        e.fric.x = 0.8
                    end
                else
                    e.fric.x = frictionRunningX
                end
            end
        end

        resetKeyPresses()
    end
end

local player = Concord.entity(Core.world)
player:assemble(playerAssemble, 160, 168)

return PlayerSystem
