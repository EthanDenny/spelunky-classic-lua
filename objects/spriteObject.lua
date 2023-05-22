require "core"

SpriteObject = class(
    Object,
    {
        sprite=nil,
        width=0,
        height=0,
        x=0,
        y=0,
        rotation=0,
        flipped=false,
        mirrored=false
    }
)

function SpriteObject:draw()
    offset = {
        x = self.width / 2,
        y = self.height / 2
    }

    love.graphics.draw(
        self.sprite,
        math.floor(self.x + 0.5),
        math.floor(self.y + 0.5),
        self.rotation,
        self.mirrored and -1 or 1,
        self.flipped and -1 or 1,
        offset.x,
        offset.y
    )
end
