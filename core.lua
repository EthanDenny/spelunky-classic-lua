-- Main table

core = {}
core.drawFunctions = {}

function core:draw()
    for _, f in ipairs(core.drawFunctions) do f() end
end

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
