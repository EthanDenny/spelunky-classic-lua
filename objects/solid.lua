require "core"
require "objects/spriteObject"

Solid = class(
    SpriteObject,
    {
        colWidth=0,
        colHeight=0,
        colX=0,
        colY=0
    }
)

function Solid:isColliding()
    for _, obj in pairs(objectList) do
        if (self ~= obj and
            self.x + self.colX < obj.x + obj.colX + obj.colWidth and
            self.y + self.colY < obj.y + obj.colY + obj.colHeight and
            self.x + self.colX + self.colWidth > obj.x + obj.colX and
            self.y + self.colY + self.colHeight > obj.y + obj.colY) then
            return true
        end
    end

    return false
end

function Solid:isColLeft()
    self.x = self.x - 1
    col = self:isColliding()
    self.x = self.x + 1
    return col
end

function Solid:isColRight()
    self.x = self.x + 1
    col = self:isColliding()
    self.x = self.x - 1
    return col
end

function Solid:isColTop()
    self.y = self.y - 1
    col = self:isColliding()
    self.y = self.y + 1
    return col
end

function Solid:isColBottom()
    self.y = self.y + 1
    col = self:isColliding()
    self.y = self.y - 1
    return col
end
