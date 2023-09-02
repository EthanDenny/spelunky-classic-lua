
local PATH = (...):gsub('%.init$', '')

local PlayerInputSystem = require(PATH..".input")
local PlayerPhysicsSystem = require(PATH..".physics")
local PlayerHangSystem = require(PATH..".hang")
local PlayerAnimSystem = require(PATH..".animation")

Core.world:addSystems(
    PlayerInputSystem,
    PlayerPhysicsSystem,
    PlayerHangSystem,
    PlayerAnimSystem
)
