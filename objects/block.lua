require "core"
require "spriteObject"

Block = class(
    SpriteObject,
    {
        sprite=love.graphics.newImage("sprites/block.png"),
        width=16,
        height=16,
    }
)

for i = 0, 19 do
    block = Block:new()
    block.x = i * 16
    block.y = 224
end
