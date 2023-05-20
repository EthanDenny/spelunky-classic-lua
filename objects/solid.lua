require "core"
require "objects/spriteObject"

Solid = class(
    SpriteObject,
    {
        col_width=0,
        col_height=0,
        col_x=0,
        col_y=0
    }
)

function Solid:isColliding()
    for _, obj in pairs(objectList) do
        if (self ~= obj and
            self.x < obj.x + obj.width and self.x + self.width > obj.x and
            self.y < obj.y + obj.height and self.y + self.height > obj.y) then
            return true
        end
    end

    return false
end
