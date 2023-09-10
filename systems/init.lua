local files = love.filesystem.getDirectoryItems("systems")

for _, file in pairs(files) do
    if file ~= "init.lua" then
        require("systems/"..file:sub(0, -5))
    end
end
