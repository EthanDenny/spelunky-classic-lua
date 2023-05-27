require "core"

SpriteObject = class(
    Object,
    {
        sprite=nil,
        imageSpeed=1,
        frame=1,
        frameTimer=0,
        frameCount=1,

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
    if self.sprite then
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
end

function SpriteObject:setSprite(image)
    self.sprite = image
    self.frameCount = self.sprite:getWidth() / self.width
end

function love.update(delta)
    for _, obj in pairs(objectList) do
        if obj.sprite then
            obj.frameTimer = obj.frameTimer + delta

            if obj.frameTimer >= obj.imageSpeed then
                obj.frameTimer = obj.frameTimer - obj.image_speed

                obj.frame = obj.frame + 1
                if obj.frame >= obj.frameCount then
                    obj.frame = 0
                end
            end

            print(obj.frame)
        end
    end
end
