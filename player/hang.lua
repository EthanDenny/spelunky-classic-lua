local Concord = require("concord")

local PlayerHangSystem = Concord.system({
    pool = {"pState"},
    colPool = {"pos", "collider", "solid"}
})

function PlayerHangSystem:update(delta)
    for _, e in ipairs(self.pool) do
        if (e.pInputs.hangCount == 0 and
            e.pos.y > 16 and
            not e.pState.onGround and
            not Collisions.colPoint(e.pos.x, e.pos.y+9, self.colPool)) then
        
            if (e.pInputs.right and
                Collisions.colRight(e, self.colPool) and (
                    Collisions.colPoint(e.pos.x+9, e.pos.y-5, self.colPool) or
                    Collisions.colPoint(e.pos.x+9, e.pos.y-6, self.colPool)
                ) and
                not Collisions.colPoint(e.pos.x+9, e.pos.y-9, self.colPool)) then

                e.pState.hanging = true
                
                -- Snap to ledge
                e.pos.y = Core.round(e.pos.y / 8) * 8

                e.vel.y = 0
                e.acc.y = 0
                e.pPhysics.grav = 0
            elseif (e.pInputs.left and
                Collisions.colLeft(e, self.colPool) and (
                    Collisions.colPoint(e.pos.x-9, e.pos.y-5, self.colPool) or
                    Collisions.colPoint(e.pos.x-9, e.pos.y-6, self.colPool)
                ) and
                not Collisions.colPoint(e.pos.x-9, e.pos.y-9, self.colPool)) then

                e.pState.hanging = true
                
                -- Snap to ledge
                e.pos.y = Core.round(e.pos.y / 8) * 8

                e.vel.y = 0
                e.acc.y = 0
                e.pPhysics.grav = 0
            end
        end

        if e.pInputs.hangCount > 0 then
            e.pInputs.hangCount = e.pInputs.hangCount - delta
        else
            e.pInputs.hangCount = 0
        end

        if e.pState.hanging then
            e.pInputs.jumped = false
            
            if e.pInputs.jumpPressed then
                e.pPhysics.grav = e.pPhysics.gravNorm
                e.pState.hanging = false

                if e.pInputs.down then
                    e.pState.jumping = false
                    e.acc.y = e.acc.y - e.pPhysics.grav
                    e.pInputs.hangCount = 5
                else
                    if ((e.orientation.mirrored and e.pInputs.left) or (not e.orientation.mirrored and e.pInputs.right)) then
                        e.pState.jumping = false
                        e.acc.y = e.acc.y - e.pPhysics.grav
                    else
                        e.pState.jumping = true
                        e.acc.y = e.acc.y + e.pPhysics.initialJumpAcc * 2 * 2

                        if e.orientation.mirrored then
                            e.pos.x = e.pos.x - 2
                        else
                            e.pos.x = e.pos.x + 2
                        end
                    end
                end
                
                e.pInputs.hangCount = 3
            end
            
            if ((not e.orientation.mirrored and not Collisions.colLeft(e, self.colPool, 2)) or
                (e.orientation.mirrored and not Collisions.colRight(e, self.colPool, 2))) then
                e.pPhysics.grav = e.pPhysics.gravNorm
                e.pState.hanging = false
                e.pState.jumping = false
                e.acc.y = e.acc.y - e.pPhysics.grav
                e.pInputs.hangCount = 4
            end
        else
            e.pPhysics.grav = e.pPhysics.gravNorm
        end
    end
end

return PlayerHangSystem
