require "core"
require "objects/solid"

-- Inputs

local kLeftReleased = false
local kLeft = false
local kRightReleased = false
local kRight = false

local kRun = false
local kAttack = false
local kUp = false
local kDown = false

local kItemPressed = false
local kItem = false

local kJumpPressed = false
local kJumpReleased = false
local kJump = false

local kLeftPushedSteps = 0
local kRightPushedSteps = 0

local runAcc = 3
local frictionRunningX = 0.6
local frictionRunningFastX = 0.98

Player = class(
    Solid,
    {
        sprite=love.graphics.newImage("sprites/player.png"),
        width=16,
        height=16,
        x=160,
        y=0,
        mirrored=true,
    
        colWidth=10,
        colHeight=16,
        colX=3,
        colY=0,

        vel={x=0, y=0},
        acc={x=0, y=0},
        fric={x=1, y=1},

        velLimit={x=16, y=10},
        accLimit={x=9, y=6},
    }
)

function Player:update(delta)
    -- Get inputs

    kLeftReleased = kLeft and not love.keyboard.isDown("left")
    kLeft = love.keyboard.isDown("left")
    kRightReleased = kRight and not love.keyboard.isDown("right")
    kRight = love.keyboard.isDown("right")

    kRun = love.keyboard.isDown("lshift")
    kAttack = love.keyboard.isDown("x")
    kUp = love.keyboard.isDown("up")
    kDown = love.keyboard.isDown("down")

    kItemPressed = not kItem and love.keyboard.isDown("c")
    kItem = love.keyboard.isDown("c")

    kJumpPressed = not kJump and love.keyboard.isDown("z")
    kJumpReleased = kJump and not love.keyboard.isDown("z")
    kJump = love.keyboard.isDown("z")

    -- Count input ticks

    if kLeft then
        kLeftPushedSteps = kLeftPushedSteps + delta
    else
        kLeftPushedSteps = 0
    end
        
    if kRight then
        kRightPushedSteps = kRightPushedSteps + delta
    else
        kRightPushedSteps = 0
    end

    -- Walking

    if kLeftReleased and approximatelyZero(self.vel.x) then self.acc.x = self.acc.x - 0.5 end
    if kRightReleased and approximatelyZero(self.vel.x) then self.acc.x = self.acc.x + 0.5 end

    if kLeft and not kRight then
        if kLeftPushedSteps > 2 then
            self.acc.x = self.acc.x - runAcc
        end
        self.mirrored = false
    end
  
    if kRight and not kLeft then
        if kRightPushedSteps > 2 then
            self.acc.x = self.acc.x + runAcc
        end
        self.mirrored = true
    end

	-- Final calculations and movement

    if self:isColBottom() and kRun then
        if kLeft then
            self.vel.x = self.vel.x - delta * 0.1
            self.velLimit.x = 6
            self.fric.x = frictionRunningFastX
        elseif kRight then
            self.vel.x = self.vel.x + delta * 0.1
            self.velLimit.x = 6
            self.fric.x = frictionRunningFastX
        else
            self.fric.x = frictionRunningX
        end
    else
        self.fric.x = frictionRunningX
    end

    self.acc.x = clamp(self.acc.x, self.accLimit.x)
	self.acc.y = clamp(self.acc.y, self.accLimit.y)

    if self:isColBottom() and not kJump and not kDown and not kRun then
		self.velLimit.x = 3
    end
	
	self.vel.x = (self.vel.x + self.acc.x) * self.fric.x
    self.vel.y = 10 -- (self.vel.y + self.acc.y) * self.fric.y

	self.acc = {x=0, y=0}
	
	self.vel.x = clamp(self.vel.x, self.velLimit.x)
	self.vel.y = clamp(self.vel.y, self.velLimit.y)
	
	if approximatelyZero(self.vel.x) then self.vel.x = 0 end
	if approximatelyZero(self.vel.y) then self.vel.y = 0 end

    self:moveTo(delta)
end

function Player:moveTo(delta)
    local xVelInteger = math.floor(math.abs(self.vel.x))
    local yVelInteger = math.floor(math.abs(self.vel.y))

    if self.vel.x < 0 then
        for i=0, xVelInteger do
            if self:isColLeft(delta) then break end
            self.x = self.x - delta
        end
    elseif self.vel.x > 0 then
        for i=0, xVelInteger do
            if self:isColRight(delta) then break end
            self.x = self.x + delta
        end
    end

    if self.vel.y < 0 then
        for i=0, yVelInteger do
            if self:isColTop(delta) then break end
            self.y = self.y - delta
        end
    elseif self.vel.y > 0 then
        for i=0, yVelInteger do
            if self:isColBottom(delta) then break end
            self.y = self.y + delta
        end
    end
end

player = Player:new()
