local Concord = require("concord")
local Keys = require("keys")
require("components")

local PlayerInputSystem = Concord.system({
    pool = {"playerInputs"},
})

function PlayerInputSystem:update(delta)
    for _, e in ipairs(self.pool) do
        -- Left and right

        if love.keyboard.isDown(Keys.left) then
            e.playerInputs.leftDown = not e.playerInputs.left
            e.playerInputs.left = true
            e.playerInputs.leftPushedSteps = e.playerInputs.leftPushedSteps + delta
        else
            e.playerInputs.leftUp = e.playerInputs.left
            e.playerInputs.left = false
            e.playerInputs.leftPushedSteps = 0
        end

        if love.keyboard.isDown(Keys.right) then
            e.playerInputs.rightDown = not e.playerInputs.right
            e.playerInputs.right = true
            e.playerInputs.rightPushedSteps = e.playerInputs.rightPushedSteps + delta
        else
            e.playerInputs.rightUp = e.playerInputs.right
            e.playerInputs.right = false
            e.playerInputs.rightPushedSteps = 0
        end

        -- Up and down

        e.playerInputs.up = love.keyboard.isDown(Keys.up)
        e.playerInputs.down = love.keyboard.isDown(Keys.down)

        -- Jumping

        if love.keyboard.isDown(Keys.jump) then
            e.playerInputs.jumpDown = not e.playerInputs.jump
            e.playerInputs.jump = true
        else
            e.playerInputs.jumpUp = e.playerInputs.jump
            e.playerInputs.jump = false
        end

        -- Attacking

        e.playerInputs.attack = love.keyboard.isDown(Keys.attack)

        -- running

        e.playerInputs.run = love.keyboard.isDown(Keys.run)

        if e.playerInputs.run then
            e.playerInputs.runHeld = 100
        end

        if not e.playerInputs.run or (not e.playerInputs.left and not e.playerInputs.right) then
            e.playerInputs.runHeld = 0
        end
        
        if e.playerInputs.attack then
            e.playerInputs.runHeld = e.playerInputs.runHeld + delta
        end

        -- Using items

        if love.keyboard.isDown(Keys.item) then
            e.playerInputs.itemDown = not e.playerInputs.item
            e.playerInputs.item = true
        else
            e.playerInputs.item = false
        end
    end
end

Core.world:addSystem(PlayerInputSystem)
