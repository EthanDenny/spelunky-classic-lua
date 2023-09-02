local Concord = require("concord")
local Keybinds = require("keybindings")

Concord.component("pInputs", function(c)
    c.leftReleased = false
    c.left = false
    c.rightReleased = false
    c.right = false

    c.run = false
    c.attack = false
    c.up = false
    c.down = false

    c.itemPressed = false
    c.item = false

    c.jumpPressed = false
    c.jumpReleased = false
    c.jump = false

    c.leftPushedSteps = 0
    c.rightPushedSteps = 0

    c.hangCount = 0
    c.runHeld = 0
end)

local PlayerInputSystem = Concord.system({
    pool = {"pInputs"},
})

function PlayerInputSystem:update(delta)
    for _, e in ipairs(self.pool) do
        -- left and right

        if love.keyboard.isDown(Keybinds.left) then
            e.pInputs.leftPressed = not e.pInputs.left
            e.pInputs.left = true
            e.pInputs.leftPushedSteps = e.pInputs.leftPushedSteps + delta
        else
            e.pInputs.leftReleased = e.pInputs.left
            e.pInputs.left = false
            e.pInputs.leftPushedSteps = 0
        end

        if love.keyboard.isDown(Keybinds.right) then
            e.pInputs.rightPressed = not e.pInputs.right
            e.pInputs.right = true
            e.pInputs.rightPushedSteps = e.pInputs.rightPushedSteps + delta
        else
            e.pInputs.rightReleased = e.pInputs.right
            e.pInputs.right = false
            e.pInputs.rightPushedSteps = 0
        end

        -- Up and down

        e.pInputs.up = love.keyboard.isDown(Keybinds.up)
        e.pInputs.down = love.keyboard.isDown(Keybinds.down)

        -- Jumping

        if love.keyboard.isDown(Keybinds.jump) then
            e.pInputs.jumpPressed = not e.pInputs.jump
            e.pInputs.jump = true
        else
            e.pInputs.jumpReleased = e.pInputs.jump
            e.pInputs.jump = false
        end

        -- Attacking

        e.pInputs.attack = love.keyboard.isDown(Keybinds.attack)

        -- running

        e.pInputs.run = love.keyboard.isDown(Keybinds.run)

        if e.pInputs.run then
            e.pInputs.runHeld = 100
        end

        if not e.pInputs.run or (not e.pInputs.left and not e.pInputs.right) then
            e.pInputs.runHeld = 0
        end
        
        if e.pInputs.attack then
            e.pInputs.runHeld = e.pInputs.runHeld + delta
        end

        -- Using items

        if love.keyboard.isDown(Keybinds.item) then
            e.pInputs.itemPressed = not e.pInputs.item
            e.pInputs.item = true
        else
            e.pInputs.item = false
        end
    end
end

return PlayerInputSystem
