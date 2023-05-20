require "core"
require "spriteObject"

Player = class(
    SpriteObject,
    {
        sprite=love.graphics.newImage("sprites/player.png"),
        width=16,
        height=16,
        x=152,
        y=0,
        mirrored=true,
    
        speed=3,
        gravity=4
    }
)

player = Player:new()

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

    player.y = player.y + delta * player.gravity
end
