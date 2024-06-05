-- enemy.lua

local bump = require "libs.bump"

local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(world, x, y, player)
    local obj = {
        x = x,
        y = y,
        width = 32,
        height = 32,
        speed = 100, -- Enemy speed is slower than player
        isMoving = false,
        moveDir = nil,
        targetX = x,
        targetY = y,
        player = player,
        world = world,
        attackCooldown = 2,
        lastAttackTime = 0,
        strength = 10, -- Damage dealt to the player
        attackRange = 34 -- Range within which the enemy can attack the player
    }
    world:add(obj, x, y, obj.width, obj.height)
    setmetatable(obj, Enemy)
    return obj
end

function Enemy:update(dt)
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
        self:moveTowardsPlayer()
    end

    -- Attack the player if within attack range and cooldown is over
    local dx = self.player.x - self.x
    local dy = self.player.y - self.y
    local dist = math.sqrt(dx * dx + dy * dy)
    if dist < self.attackRange and love.timer.getTime() - self.lastAttackTime > self.attackCooldown then
        self.player:takeDamage(self.strength)
        self.lastAttackTime = love.timer.getTime()
    end
end

function Enemy:moveTowardsPlayer()
    local dx = self.player.x - self.x
    local dy = self.player.y - self.y
    if math.abs(dx) > math.abs(dy) then
        if dx > 0 then
            self:move("right")
        else
            self:move("left")
        end
    else
        if dy > 0 then
            self:move("down")
        else
            self:move("up")
        end
    end
end

function Enemy:move(dir)
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

function Enemy:draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Draw attack range for debugging purposes
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.circle("line", self.x + self.width / 2, self.y + self.height / 2, self.attackRange)
end

return Enemy
