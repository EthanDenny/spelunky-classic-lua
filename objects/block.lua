require "core"
require "objects/solid"

Block = class(
    Solid,
    {
        sprite=love.graphics.newImage("sprites/block.png"),
        width=16,
        height=16,

        colWidth=16,
        colHeight=16
    }
)

local block

for x = 0, 19 do
    for y = 0, 2 do
        block = Block:new()
        block.x = x * 16 + 8
        block.y = y * 16 + 200
    end
end

block = Block:new()
block.x = 152
block.y = 184

block = Block:new()
block.x = 168
block.y = 184
