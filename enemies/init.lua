local PATH = (...):gsub('%.init$', '')

local SpiderAISystem = require(PATH..".spider")

Core.world:addSystems(
    SpiderAISystem
)
