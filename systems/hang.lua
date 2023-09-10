local Concord = require("concord")
require("components")

local PlayerHangSystem = Concord.system({
    pool = {"player"},
    colPool = {"pos", "collider", "solid"}
})

function PlayerHangSystem:update(delta)
    for _, e in ipairs(self.pool) do
        if (e.playerInputs.hangCount == 0 and
            e.pos.y > 16 and
            not e:has("onGround") and
            not Collisions.colPoint(e.pos.x, e.pos.y+9, self.colPool)) then

            if (e.playerInputs.right and
                Collisions.colRight(e, self.colPool) and (
                    Collisions.colPoint(e.pos.x+9, e.pos.y-5, self.colPool) or
                    Collisions.colPoint(e.pos.x+9, e.pos.y-6, self.colPool)
                ) and
                not Collisions.colPoint(e.pos.x+9, e.pos.y-9, self.colPool)) then

                e:give("hanging")

                -- Snap to ledge
                e.pos.y = Core.round(e.pos.y / 8) * 8

                e.vel.y = 0
                e.acc.y = 0
                e.playerPhysics.grav = 0
            elseif (e.playerInputs.left and
                Collisions.colLeft(e, self.colPool) and (
                    Collisions.colPoint(e.pos.x-9, e.pos.y-5, self.colPool) or
                    Collisions.colPoint(e.pos.x-9, e.pos.y-6, self.colPool)
                ) and
                not Collisions.colPoint(e.pos.x-9, e.pos.y-9, self.colPool)) then

                e:give("hanging")

                -- Snap to ledge
                e.pos.y = Core.round(e.pos.y / 8) * 8

                e.vel.y = 0
                e.acc.y = 0
                e.playerPhysics.grav = 0
            end
        end

        if e.playerInputs.hangCount > 0 then
            e.playerInputs.hangCount = e.playerInputs.hangCount - delta
        else
            e.playerInputs.hangCount = 0
        end

        if e:has("hanging") then
            e.playerInputs.jumped = false

            if e.playerInputs.jumpDown then
                e.playerPhysics.grav = e.playerPhysics.gravNorm
                e:remove("hanging")

                if e.playerInputs.down then
                    e:remove("jumping")
                    e.acc.y = e.acc.y - e.playerPhysics.grav
                    e.playerInputs.hangCount = 5
                else
                    if ((e.orientation.mirrored and e.playerInputs.left) or (not e.orientation.mirrored and e.playerInputs.right)) then
                        e:remove("jumping")
                        e.acc.y = e.acc.y - e.playerPhysics.grav
                    else
                        e:give("jumping")
                        e.acc.y = e.acc.y + e.playerPhysics.initialJumpAcc * 2 * 2

                        if e.orientation.mirrored then
                            e.pos.x = e.pos.x - 2
                        else
                            e.pos.x = e.pos.x + 2
                        end
                    end
                end

                e.playerInputs.hangCount = 3
            end

            if ((not e.orientation.mirrored and not Collisions.colLeft(e, self.colPool, 2)) or
                (e.orientation.mirrored and not Collisions.colRight(e, self.colPool, 2))) then
                e.playerPhysics.grav = e.playerPhysics.gravNorm
                e:remove("hanging")
                e:remove("jumping")
                e.acc.y = e.acc.y - e.playerPhysics.grav
                e.playerInputs.hangCount = 4
            end
        else
            e.playerPhysics.grav = e.playerPhysics.gravNorm
        end
    end
end

Core.world:addSystems(PlayerHangSystem)
