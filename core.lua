-- Main table

core = {}
core.drawFunctions = {}

function core:draw()
    for _, f in ipairs(core.drawFunctions) do f() end
end

-- Object class

Object = {}

function Object:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
