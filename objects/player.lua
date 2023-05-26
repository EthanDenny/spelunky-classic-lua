require "core"
require "objects/solid"
require "keybindings"

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

function love.keypressed(key, scancode)
    if scancode == keybinds.jump then kJumpPressed = true end
    if scancode == keybinds.item then kItemPressed = true end
end

function love.keyreleased(key, scancode)
    if scancode == keybinds.left then kLeftReleased = true end
    if scancode == keybinds.right then kRightReleased = true end
    if scancode == keybinds.jump then kJumpReleased = true end
end

function resetKeyPresses()
    kLeftReleased = false
    kRightReleased = false
    kJumpPressed = false
    kJumpReleased = false
    kItemPressed = false
end

-- Physics

local grav = 1
local gravNorm = 1
local gravityIntensity = grav

local xVelLimit = 16
local yVelLimit = 10
local xAccLimit = 9
local yAccLimit = 6
local runAcc = 3

local initialJumpAcc = -2
local jumpTimeTotal = 10
local jumpTime = jumpTimeTotal

local frictionRunningX = 0.6
local frictionRunningFastX = 0.98

-- Player

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

        -- States

        isDucking = false,
        isLookingUp = false,

        isOnGround = false,
        isClimbing = false,
        isJumping = false,

        isDuckingToHang = false,
        isHanging = false,
    }
)

function Player:update(delta)
    -- Get inputs

    kLeft = love.keyboard.isDown(keybinds.left)
    kRight = love.keyboard.isDown(keybinds.right)
    kUp = love.keyboard.isDown(keybinds.up)
    kDown = love.keyboard.isDown(keybinds.down)

    kRun = love.keyboard.isDown(keybinds.run)
    kJump = love.keyboard.isDown(keybinds.jump)
    kAttack = love.keyboard.isDown(keybinds.attack)

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

    if kRun then
        runHeld = 100
    end
    
    if kAttack then
        runHeld = runHeld + delta
    end

    if not kRun or (not kLeft and not kRight) then
        runHeld = 0
    end

    -- Walking

    if not self.isClimbing and not self.isHanging then
        if kLeftReleased and approximatelyZero(self.vel.x) then self.acc.x = self.acc.x - 0.5 end
        if kRightReleased and approximatelyZero(self.vel.x) then self.acc.x = self.acc.x + 0.5 end

        if kLeft and not kRight then
            if kLeftPushedSteps > 2 and (not self.mirrored or approximatelyZero(self.vel.x)) then
                self.acc.x = self.acc.x - runAcc
            end
            self.mirrored = false
        end
    
        if kRight and not kLeft then
            if kRightPushedSteps > 2 and (self.mirrored or approximatelyZero(self.vel.x)) then
                self.acc.x = self.acc.x + runAcc
            end
            self.mirrored = true
        end
    end

    if self:isColBottom() and not kJump and not kDown and not kRun then
        xVelLimit = 3
    end

    -- Bouncing off solids

    if self:isColTop() then
        if dead or stunned then
            self.vel.y = -self.vel.y * 0.8
        elseif not self.isOnGround and self.isJumping then
            self.vel.y = math.abs(self.vel.y * 0.3)
        end
    end

    if (self:isColLeft() and not self.mirrored) or (self:isColRight() and self.mirrored) then
        if dead or stunned then
            self.vel.x = -self.vel.x * 0.5
        else
            self.vel.x = 0
        end
    end

    -- Jumping

    if not self.isOnGround and not self.isHanging then
        self.acc.y = self.acc.y + gravityIntensity * delta
    end

    if self:isColBottom() then
        self.isOnGround = true
        self.vel.y = 0
        self.acc.y = 0
    end

    if not self:isColBottom() and self.isOnGround then
        self.isOnGround = false
        self.isJumping = false
        self.acc.y = self.acc.y + grav * delta
    end

    if self.isOnGround and kJumpPressed then
        if math.abs(self.vel.x) > 3 then
            self.acc.x = self.acc.x + self.vel.x * 2
        else
            self.acc.x = self.acc.x + self.vel.x / 2
        end

        self.acc.y = self.acc.y + initialJumpAcc * 2

        yAccLimit = 6
        grav = gravNorm

        self.isOnGround = false

        jumpTime = 0
    end

    if jumpTime < jumpTimeTotal then
        jumpTime = jumpTime + delta
    end

    if kJumpReleased then
        jumpTime = jumpTimeTotal
    end

    gravityIntensity = (jumpTime / jumpTimeTotal) * grav

    -- Changing states

    self.isLookingUp = kUp and self.isOnGround

    if kDown then
        self.isDucking = self.isOnGround
    elseif self.isDucking then
        self.isDucking = false
        self.vel.x = 0
        self.acc.x = 0
    end

    if self.vel.y < 0 and not self.isOnGround and not self.isHanging then
        self.isJumping = true
    end

    if self.vel.y > 0 and not self.isOnGround and not self.isHanging then
        self.isJumping = true
        self.colHeight = 14
        self.colY = 2
    else
        self.colHeight = 16
        self.colY = 0
    end

    -- Calculate friction

    if not self.isClimbing then
        if kRun and self.isOnGround and runHeld >= 10 then
            if kLeft then
                self.vel.x = self.vel.x - delta * 0.1
                xVelLimit = 6
                self.fric.x = frictionRunningFastX
            elseif kRight then
                self.vel.x = self.vel.x + delta * 0.1
                xVelLimit = 6
                self.fric.x = frictionRunningFastX
            end
        elseif self.isDucking then
            if math.abs(self.vel.x) < 2 then
                self.fric.x = 0.2
                xVelLimit = 3
                image_speed = 0.8
            else
                self.vel.x = self.vel.x * 0.8
                if self.vel.x < 0.5 then self.vel.x = 0 end
                self.fric.x = 0.2
                xVelLimit = 3
                image_speed = 0.8
            end
        else
            if not self.isOnGround then
                if dead or stunned then
                    self.fric.x = 1.0
                else
                    self.fric.x = 0.8
                end
            else
                self.fric.x = frictionRunningX
            end
        end
    end

    -- Final calculations and movement

    self.acc.x = clamp(self.acc.x, xAccLimit)
    self.acc.y = clamp(self.acc.y, yAccLimit)

    self.vel.x = (self.vel.x + self.acc.x) * self.fric.x
    self.vel.y = (self.vel.y + self.acc.y) * self.fric.y

    self.acc = {x=0, y=0}

    self.vel.x = clamp(self.vel.x, xVelLimit)
    self.vel.y = clamp(self.vel.y, yVelLimit)
    
    if approximatelyZero(self.vel.x) then self.vel.x = 0 end
    if approximatelyZero(self.vel.y) then self.vel.y = 0 end

    self:moveTo(delta)

    resetKeyPresses()
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
