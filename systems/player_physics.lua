local Concord = require("Concord")
local Collisions = require("collisions")
local Core = require("core")
require("components")

local PlayerPhysicsSystem = Concord.system({
    pool = {"player"},
    colPool = {"pos", "collider", "solid"}
})

function PlayerPhysicsSystem:update(delta)
    for _, e in ipairs(self.pool) do
        -- Walking

        if not e:has("climbing") and not e:has("hanging") then
            if e.playerInputs.leftUp and Core.approximatelyZero(e.vel.x) then e.acc.x = e.acc.x - 0.5 end
            if e.playerInputs.rightUp and Core.approximatelyZero(e.vel.x) then e.acc.x = e.acc.x + 0.5 end

            if e.playerInputs.left and not e.playerInputs.right then
                if e.playerInputs.leftPushedSteps > 2 and (not e.orientation.mirrored or Core.approximatelyZero(e.vel.x)) then
                    e.acc.x = e.acc.x - e.playerPhysics.runAcc
                end
                e.orientation.mirrored = false
            end

            if e.playerInputs.right and not e.playerInputs.left then
                if e.playerInputs.rightPushedSteps > 2 and (e.orientation.mirrored or Core.approximatelyZero(e.vel.x)) then
                    e.acc.x = e.acc.x + e.playerPhysics.runAcc
                end
                e.orientation.mirrored = true
            end
        end

        if Collisions.colBottom(e, self.colPool) and not e.playerInputs.jump and not e.playerInputs.down and not e.playerInputs.run then
            e.vel.limit.x = 3
        end

        -- Bouncing off solids

        if Collisions.colTop(e, self.colPool) then
            if e:has("dead") or e:has("stunned") then
                e.vel.y = -e.vel.y * 0.8
            elseif not e:has("onGround") and e:has("jumping") then
                e.vel.y = math.abs(e.vel.y * 0.3)
            end
        end

        if (Collisions.colLeft(e, self.colPool) and not e.orientation.mirrored) or (Collisions.colRight(e, self.colPool) and e.orientation.mirrored) then
            if e:has("dead") or e:has("stunned") then
                e.vel.x = -e.vel.x * 0.5
            else
                e.vel.x = 0
            end
        end

        -- Jumping

        if not e:has("onGround") and not e:has("hanging") then
            e.acc.y = e.acc.y + e.playerPhysics.gravityIntensity * delta
        end

        if Collisions.colBottom(e, self.colPool, 0.1) then -- Use a small interval to prevent false positives
            e:give("onGround")
            e.vel.y = 0
            e.acc.y = 0
        end

        if not Collisions.colBottom(e, self.colPool) and e:has("onGround") then
            e:remove("onGround")
            e.acc.y = e.acc.y + e.playerPhysics.grav * delta
        end

        if e:has("onGround") and e.playerInputs.jumpDown then
            if math.abs(e.vel.x) > 3 then
                e.acc.x = e.acc.x + e.vel.x * 2
            else
                e.acc.x = e.acc.x + e.vel.x / 2
            end

            e.acc.y = e.acc.y + e.playerPhysics.initialJumpAcc * 2

            e.acc.limit.y = 6
            e.playerPhysics.grav = e.playerPhysics.gravNorm

            e:remove("onGround")

            e.playerPhysics.jumpTime = 0
        end

        if e.playerPhysics.jumpTime < e.playerPhysics.jumpTimeTotal then
            e.playerPhysics.jumpTime = e.playerPhysics.jumpTime + delta
        end

        if e.playerInputs.jumpUp then
            e.playerPhysics.jumpTime = e.playerPhysics.jumpTimeTotal
        end

        e.playerPhysics.gravityIntensity = (e.playerPhysics.jumpTime / e.playerPhysics.jumpTimeTotal) * e.playerPhysics.grav

        -- Changing states

        if e.playerInputs.up and e:has("onGround") then
            e:give("lookingUp")
        else
            e:remove("lookingUp")
        end

        if e.playerInputs.down then
            if e:has("onGround") then
                e:give("ducking")
            else
                e:remove("ducking")
            end
        elseif e:has("ducking") then
            e:remove("ducking")
            e.vel.x = 0
            e.acc.x = 0
        end

        if e.vel.y < 0 and not e:has("onGround") and not e:has("hanging") then
            e:give("jumping")
        end

        if e.vel.y > 0 and not e:has("onGround") and not e:has("hanging") then
            e:remove("jumping")
            e.collider.size.y = 14
            e.collider.offset.y = 2
        else
            e.collider.size.y = 16
            e.collider.offset.y = 0
        end

        -- Calculate friction

        if not e:has("climbing") then
            if e.playerInputs.run and e:has("onGround") and e.playerInputs.runHeld >= 10 then
                if e.playerInputs.left then
                    e.vel.x = e.vel.x - delta * 0.1
                    e.vel.limit.x = 6
                    e.fric.x = e.playerPhysics.frictionrunningFastX
                    e:remove("ducking")
                elseif e.playerInputs.right then
                    e.vel.x = e.vel.x + delta * 0.1
                    e.vel.limit.x = 6
                    e.fric.x = e.playerPhysics.frictionrunningFastX
                    e:remove("ducking")
                end
            elseif e:has("ducking") then
                e.fric.x = 0.2
                e.vel.limit.x = 3

                if math.abs(e.vel.x) >= 2 then
                    e.vel.x = e.vel.x * 0.8
                end
            else
                if not e:has("onGround") then
                    if e:has("dead") or e:has("stunned") then
                        e.fric.x = 1.0
                    else
                        e.fric.x = 0.8
                    end
                else
                    e.fric.x = e.playerPhysics.frictionrunningX
                end
            end
        end
    end
end

Core.world:addSystem(PlayerPhysicsSystem)
