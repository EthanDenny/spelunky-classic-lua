require "core"
require "spriteObject"

player = SpriteObject:new({
    sprite=love.graphics.newImage("player.png"),
    width=16,
    height=16,
    x=16,
    y=16,
    mirrored=true
})

function love.update(dt)
    delta = dt * 30

    player.x = player.x + delta * 3.2 / 12
    player.y = player.y + delta * 2.4 / 12
end
