require "core"

SpriteObject = Object:new({
    sprite=nil,
    width=0,
    height=0,
    x=0,
    y=0,
    rotation=0,
    flipped=false,
    mirrored=false
})

function SpriteObject:init()
    table.insert(SpriteObjectList, self)
end

SpriteObjectList = {}

function SpriteObjectList:draw()
    for _, obj in ipairs(SpriteObjectList) do
        offset = {
            x = obj.width / 2,
            y = obj.height / 2
        }

        love.graphics.draw(
            obj.sprite,
            math.floor(obj.x + offset.x + 0.5),
            math.floor(obj.y + offset.y + 0.5),
            obj.rotation,
            obj.mirrored and -1 or 1,
            obj.flipped and -1 or 1,
            offset.x,
            offset.y
        )
    end
end

table.insert(core.drawFunctions, SpriteObjectList.draw)
