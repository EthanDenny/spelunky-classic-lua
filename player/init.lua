local Concord = require("concord")
local Core = require("core")
local DrawSystem = require("draw")
local PhysicsSystem = require("physics")

local PATH = (...):gsub('%.init$', '')

local PlayerInputSystem = require(PATH..".input")
local PlayerPhysicsSystem = require(PATH..".physics")
local PlayerHangSystem = require(PATH..".hang")
local PlayerAnimSystem = require(PATH..".animation")

local sRunLeft = love.graphics.newImage("sprites/PlayerRun.png")

function playerAssemble(e, x, y)
    e
    :give("animatedSprite", sRunLeft, 6, 0.4)
    :give("pos", x, y)
    :give("size", 16, 16)
    :give("orientation")
    :give("collider", {x=10, y=16}, {x=3, y=0})
    :give("vel", 0, 0, {x=16, y=10})
    :give("acc", 0, 0, {x=9, y=6})
    :give("fric")
    :give("pState")
    :give("pInputs")
    :give("pPhysics")
end

local player = Concord.entity(Core.world)
player:assemble(playerAssemble, 160, 100)

Core.world:addSystems(
    PlayerInputSystem,
    PlayerPhysicsSystem,
    PlayerHangSystem,
    PlayerAnimSystem
)
