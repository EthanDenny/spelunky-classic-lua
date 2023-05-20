require "core"
require "objects/solid"

Block = class(
    Solid,
    {
        sprite=love.graphics.newImage("sprites/block.png"),
        width=16,
        height=16,

        col_width=16,
        col_height=16
    }
)

for x = 0, 19 do
    for y = 0, 2 do
        block = Block:new()
        block.x = x * 16
        block.y = y * 16 + 192
    end
end
