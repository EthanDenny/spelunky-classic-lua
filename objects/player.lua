require "core"
require "spriteObject"

player = SpriteObject:new({
    sprite=love.graphics.newImage("sprites/player.png"),
    width=16,
    height=16,
    x=152,
    y=208,
    mirrored=true,

    speed=3
})

player:init()

function love.update(dt)
    delta = dt * 30

    if love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
        player.x = player.x - delta * player.speed
        player.mirrored = false
    end
    
    if love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
        player.x = player.x + delta * player.speed
        player.mirrored = true
    end
end
