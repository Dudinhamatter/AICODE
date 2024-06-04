-- player.lua

local bump = require "libs.bump"

local Player = {}
Player.__index = Player

function Player:new(world, x, y)
    local obj = {
        x = x,
        y = y,
        width = 32,
        height = 32,
        speed = 200,
        isMoving = false,
        moveDir = nil,
        targetX = x,
        targetY = y,
        hp = 30,
        world = world,
        isFlashing = false,
        flashDuration = 0.1,
        flashTime = 0
    }
    world:add(obj, x, y, obj.width, obj.height)
    setmetatable(obj, Player)
    return obj
end

function Player:update(dt)
    if self.isMoving then
        local deltaX = 0
        local deltaY = 0

        if self.moveDir == "up" then
            deltaY = -self.speed * dt
        elseif self.moveDir == "down" then
            deltaY = self.speed * dt
        elseif self.moveDir == "left" then
            deltaX = -self.speed * dt
        elseif self.moveDir == "right" then
            deltaX = self.speed * dt
        end

        local newX = self.x + deltaX
        local newY = self.y + deltaY

        if ((self.moveDir == "up" and newY <= self.targetY) or
            (self.moveDir == "down" and newY >= self.targetY) or
            (self.moveDir == "left" and newX <= self.targetX) or
            (self.moveDir == "right" and newX >= self.targetX)) then

            self.x = self.targetX
            self.y = self.targetY
            self.isMoving = false
        else
            self.x = newX
            self.y = newY
        end

        self.world:move(self, self.x, self.y)
    else
        if love.keyboard.isDown('up') then
            self:move("up")
        elseif love.keyboard.isDown('down') then
            self:move("down")
        elseif love.keyboard.isDown('left') then
            self:move("left")
        elseif love.keyboard.isDown('right') then
            self:move("right")
        end
    end

    if self.isFlashing then
        self.flashTime = self.flashTime - dt
        if self.flashTime <= 0 then
            self.isFlashing = false
        end
    end
end

function Player:move(dir)
    if not self.isMoving then
        local newX, newY = self.x, self.y
        if dir == "up" then
            newY = self.y - 32
        elseif dir == "down" then
            newY = self.y + 32
        elseif dir == "left" then
            newX = self.x - 32
        elseif dir == "right" then
            newX = self.x + 32
        end

        local actualX, actualY, cols, len = self.world:move(self, newX, newY)
        if actualX == newX and actualY == newY then
            self.targetX = newX
            self.targetY = newY
            self.moveDir = dir
            self.isMoving = true
        end
    end
end

function Player:takeDamage(amount)
    self.hp = self.hp - amount
    self.isFlashing = true
    self.flashTime = self.flashDuration
end

function Player:draw()
    if self.isFlashing then
        love.graphics.setColor(1, 1, 1)
    else
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Player
