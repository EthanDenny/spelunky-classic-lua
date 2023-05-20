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

for i = 0, 19 do
    block = Block:new()
    block.x = i * 16
    block.y = 224
end
