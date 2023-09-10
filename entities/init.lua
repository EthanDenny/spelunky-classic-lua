local Entities = {}

local files = love.filesystem.getDirectoryItems("entities")

for _, file in pairs(files) do
    if file ~= "init.lua" then
        local name = file:sub(0, -5)
        Entities[name] = require("entities/"..name)
    end
end

return Entities
