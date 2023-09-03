local Concord = require("concord")
local Collisions = require("collisions")

Concord.component("pState", function(c)
    c.ducking = false
    c.lookingUp = false

    c.onGround = false
    c.climbing = false
    c.jumping = false

    c.duckingToHang = false
    c.hanging = false
end)

Concord.component("pPhysics", function(c)
    c.grav = 1
    c.gravNorm = 1
    c.gravityIntensity = c.grav
    
    c.runAcc = 3
    
    c.initialJumpAcc = -2
    c.jumpTimeTotal = 10
    c.jumpTime = c.jumpTimeTotal
    
    c.frictionrunningX = 0.6
    c.frictionrunningFastX = 0.98
end)

--[[
    MAIN SYSTEM
]]

local PlayerPhysicsSystem = Concord.system({
    pool = {"pState"},
    colPool = {"pos", "collider", "solid"}
})

function PlayerPhysicsSystem:update(delta)
    for _, e in ipairs(self.pool) do
        -- Walking

        if not e.pState.climbing and not e.pState.hanging then
            if e.pInputs.leftReleased and Core.approximatelyZero(e.vel.x) then e.acc.x = e.acc.x - 0.5 end
            if e.pInputs.rightReleased and Core.approximatelyZero(e.vel.x) then e.acc.x = e.acc.x + 0.5 end

            if e.pInputs.left and not e.pInputs.right then
                if e.pInputs.leftPushedSteps > 2 and (not e.orientation.mirrored or Core.approximatelyZero(e.vel.x)) then
                    e.acc.x = e.acc.x - e.pPhysics.runAcc
                end
                e.orientation.mirrored = false
            end
        
            if e.pInputs.right and not e.pInputs.left then
                if e.pInputs.rightPushedSteps > 2 and (e.orientation.mirrored or Core.approximatelyZero(e.vel.x)) then
                    e.acc.x = e.acc.x + e.pPhysics.runAcc
                end
                e.orientation.mirrored = true
            end
        end

        if Collisions.colBottom(e, self.colPool) and not e.pInputs.jump and not e.pInputs.down and not e.pInputs.run then
            e.vel.limit.x = 3
        end

        -- Bouncing off solids

        if Collisions.colTop(e, self.colPool) then
            if dead or stunned then
                e.vel.y = -e.vel.y * 0.8
            elseif not e.pState.onGround and e.pState.jumping then
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

        if not e.pState.onGround and not e.pState.hanging then
            e.acc.y = e.acc.y + e.pPhysics.gravityIntensity * delta
        end

        if Collisions.colBottom(e, self.colPool, 0.1) then -- Use a small interval to prevent false positives
            e.pState.onGround = true
            e.vel.y = 0
            e.acc.y = 0
        end

        if not Collisions.colBottom(e, self.colPool) and e.pState.onGround then
            e.pState.onGround = false
            e.acc.y = e.acc.y + e.pPhysics.grav * delta
        end

        if e.pState.onGround and e.pInputs.jumpPressed then
            if math.abs(e.vel.x) > 3 then
                e.acc.x = e.acc.x + e.vel.x * 2
            else
                e.acc.x = e.acc.x + e.vel.x / 2
            end

            e.acc.y = e.acc.y + e.pPhysics.initialJumpAcc * 2

            e.acc.limit.y = 6
            e.pPhysics.grav = e.pPhysics.gravNorm

            e.pState.onGround = false

            e.pPhysics.jumpTime = 0
        end

        if e.pPhysics.jumpTime < e.pPhysics.jumpTimeTotal then
            e.pPhysics.jumpTime = e.pPhysics.jumpTime + delta
        end

        if e.pInputs.jumpReleased then
            e.pPhysics.jumpTime = e.pPhysics.jumpTimeTotal
        end

        e.pPhysics.gravityIntensity = (e.pPhysics.jumpTime / e.pPhysics.jumpTimeTotal) * e.pPhysics.grav

        -- Changing states

        e.pState.lookingUp = e.pInputs.up and e.pState.onGround

        if e.pInputs.down then
            e.pState.ducking = e.pState.onGround
        elseif e.pState.ducking then
            e.pState.ducking = false
            e.vel.x = 0
            e.acc.x = 0
        end

        if e.vel.y < 0 and not e.pState.onGround and not e.pState.hanging then
            e.pState.jumping = true
        end

        if e.vel.y > 0 and not e.pState.onGround and not e.pState.hanging then
            e.pState.jumping = false
            e.collider.size.y = 14
            e.collider.offset.y = 2
        else
            e.collider.size.y = 16
            e.collider.offset.y = 0
        end

        -- Calculate friction

        if not e.pState.climbing then
            if e.pInputs.run and e.pState.onGround and e.pInputs.runHeld >= 10 then
                if e.pInputs.left then
                    e.vel.x = e.vel.x - delta * 0.1
                    e.vel.limit.x = 6
                    e.fric.x = e.pPhysics.frictionrunningFastX
                    e.pState.ducking = false
                elseif e.pInputs.right then
                    e.vel.x = e.vel.x + delta * 0.1
                    e.vel.limit.x = 6
                    e.fric.x = e.pPhysics.frictionrunningFastX
                    e.pState.ducking = false
                end
            elseif e.pState.ducking then
                e.fric.x = 0.2
                e.vel.limit.x = 3

                if math.abs(e.vel.x) >= 2 then
                    e.vel.x = e.vel.x * 0.8
                end
            else
                if not e.pState.onGround then
                    if dead or stunned then
                        e.fric.x = 1.0
                    else
                        e.fric.x = 0.8
                    end
                else
                    e.fric.x = e.pPhysics.frictionrunningX
                end
            end
        end
    end
end

return PlayerPhysicsSystem
