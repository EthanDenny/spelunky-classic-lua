local Concord = require("Concord")

--[[
    Transform
]]

Concord.component("pos", function(c, x, y)
    c.x = x or 0
    c.y = y or 0
end)

Concord.component("size", function(c, x, y)
    c.x = x or 0
    c.y = y or 0
end)

Concord.component("orientation", function(c, rotation, flipped, mirrored)
    c.rotation = rotation or 0
    c.flipped = flipped or false -- vertical
    c.mirrored = mirrored or false -- horizontal
end)

--[[
    Visuals
]]

Concord.component("sprite", function(c, sheet)
    c.sheet = sheet
end)

Concord.component("animatedSprite", function(c, sheet, frameCount, speed)
    c.sheet = sheet
    c.frameCount = frameCount or 1
    c.frameWidth = sheet:getWidth() / frameCount
    c.frameHeight = sheet:getHeight()
    c.frameQuad = love.graphics.newQuad(
        0,
        0,
        c.frameWidth,
        c.frameHeight,
        sheet
    )
    c.speed = speed or 1
    c.frameNumber = 0
    c.frameTimer = 0
end)

--[[
    Collisions
]]

Concord.component("collider", function(c, size, offset)
    c.size = size or {x=0, y=0}
    c.offset = offset or {x=0, y=0}
end)

Concord.component("solid")

--[[
    Physics
]]

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

--[[
    Player
]]

Concord.component("player")

Concord.component("ducking")
Concord.component("lookingUp")
Concord.component("onGround")
Concord.component("climbing")
Concord.component("jumping")
Concord.component("duckingToHang")
Concord.component("hanging")
Concord.component("dead")
Concord.component("stunned")

Concord.component("playerPhysics", function(c)
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

-- Up = Just released
-- Down = Just pressed
-- Neither = Held

Concord.component("playerInputs", function(c)
    c.leftUp = false
    c.left = false
    c.rightUp = false
    c.right = false

    c.run = false
    c.attack = false
    c.up = false
    c.down = false

    c.itemDown = false
    c.item = false

    c.jumpDown = false
    c.jumpUp = false
    c.jump = false

    c.leftPushedSteps = 0
    c.rightPushedSteps = 0

    c.hangCount = 0
    c.runHeld = 0
end)

--[[
    Entities
]]

Concord.component("spider", function(c)
    c.state = "IDLE"
    c.stateTimer = 0
    c.grav = 0.2
end)

--[[
    Tiles
]]

Concord.component("ladder")
Concord.component("walkable")
Concord.component("spikes")
