local Concord = require("concord")
local Collisions = require("collisions")
local DrawSystem = require("spriteObject")

-- Block assemblage

local blockSprite = love.graphics.newImage("sprites/block.png")

function blockAssemble(e, x, y)
    e
    :give("sprite", blockSprite)
    :give("pos", x, y)
    :give("size", 16, 16)
    :give("collider", {x=16, y=16})
    :give("solid")
end

-- Spawn blocks

local blockInstance

for x = 0, 19 do
    for y = 0, 2 do
        blockInstance = Concord.entity(Core.world)
        blockInstance:assemble(blockAssemble, x * 16 + 8, y * 16 + 200)
    end
end

blockInstance = Concord.entity(Core.world)
blockInstance:assemble(blockAssemble, 152, 184)

blockInstance = Concord.entity(Core.world)
blockInstance:assemble(blockAssemble, 168, 184)
