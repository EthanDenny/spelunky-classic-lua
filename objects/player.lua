require "core"
require "objects/solid"

Player = class(
    Solid,
    {
        sprite=love.graphics.newImage("sprites/player.png"),
        width=16,
        height=16,
        x=152,
        y=0,
        mirrored=true,
    
        col_width=10,
        col_height=16,
        col_x=3,
        col_y=0,

        speed=3,
        gravity=4
    }
)

function Player:update(delta)
    if love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
        self.x = self.x - delta * self.speed
        self.mirrored = false
    end
    
    if love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
        self.x = self.x + delta * self.speed
        self.mirrored = true
    end

    local remaining_distance = delta * self.gravity

    for i=0, remaining_distance do
        self.y = self.y + 1
        if self:isColliding() then
            self.y = self.y - 1
            break
        end
    end
end

player = Player:new()

function love.update(dt)
    player:update(dt * 30)
end
