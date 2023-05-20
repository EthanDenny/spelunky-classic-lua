core = {}

-- Object class

Object = {}

objectList = {} -- Table of Object refs

function Object:new(o, is_class)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    if not is_class then
        table.insert(objectList, o)
    end
    
    return o
end

function class(inherit, props)
    return inherit:new(props, true)
end

-- Per-frame functions

function core:update(delta)
    for _, obj in pairs(objectList) do
        if obj.update then obj:update(delta) end
    end
end

function core:draw()
    for _, obj in pairs(objectList) do
        if obj.draw then obj:draw() end
    end
end
