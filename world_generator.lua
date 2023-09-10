local Entities = require("entities")

local WorldGenerator = {}

WorldGenerator.createLevel = function()
    Entities.player.spawn(64, 64)

    Entities.spider.spawn(64, 64)
    Entities.spider.spawn(64, 64)
    Entities.spider.spawn(64, 64)

    --[[
    Entities.block.spawn(152, 184)
    Entities.block.spawn(152, 184 - 16)
    Entities.block.spawn(152 + 16, 184)
    Entities.block.spawn(152 + 16, 184 - 16)
    Entities.block.spawn(152 + 16, 184 - 32)
    Entities.block.spawn(152 + 16, 184 - 48)
    Entities.block.spawn(152 + 48, 184)
    Entities.block.spawn(152 + 48, 184 - 16)
    ]]

    for _, x in ipairs({0, 41}) do
        for y = 0, 33 do
            Entities.block.spawn(x * 16 + 8, y * 16 + 8)
        end
    end

    for x = 0, 41 do
        for _, y in ipairs({0, 33}) do
            Entities.block.spawn(x * 16 + 8, y * 16 + 8)
        end
    end

    for y = 0, 3 do
        local not_there = math.random(0, 3)
        for x = 0, 3 do
            if x ~= not_there and y < 3 then
                for X = x * 10 + 1, x * 10 + 11 do
                    Entities.block.spawn(X * 16 + 8, (y + 1) * 16 * 8 + 8)
                end
            end
        end
    end
end

return WorldGenerator
