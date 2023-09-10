local PATH = (...):gsub('%.init$', '')

local Entities = {}

Entities.player = require(PATH..".player")
Entities.spider = require(PATH..".spider")
Entities.block = require(PATH..".block")

return Entities
