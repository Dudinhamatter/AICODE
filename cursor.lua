local Cursor = {}
Cursor.__index = Cursor

function Cursor:new(world, x, y)
    local this = {
        x = x,
        y = y,
        targetX = x,
        targetY = y,
        size = 32,
        grow = true,
        scale = 1,
        speed = 12,  -- Pixels per second
        world = world,
        animationSpeed = 0.35,
        animationTimer = 0,
        lineWidth = 3  -- Thicker line width
    }
    setmetatable(this, Cursor)
    return this
end

function Cursor:update(dt)
    local mouseX, mouseY = love.mouse.getPosition()

    -- Calculate target position on the grid
    self.targetX = math.floor(mouseX / self.size) * self.size
    self.targetY = math.floor((mouseY + self.size/2)/ self.size) * self.size

    -- Smooth movement
    local dx = self.targetX - self.x
    local dy = self.targetY - self.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance > 0 then
        local moveX = dx / distance * self.speed * distance * dt
        local moveY = dy / distance * self.speed * distance * dt

        if math.abs(moveX) > math.abs(dx) then
            moveX = dx
        end

        if math.abs(moveY) > math.abs(dy) then
            moveY = dy
        end

        self.x = self.x + moveX
        self.y = self.y + moveY
    end

    -- Animation logic
    self.animationTimer = self.animationTimer + dt
    if self.animationTimer >= self.animationSpeed then
        self.animationTimer = 0
        if self.grow then
            self.scale = self.scale + 0.1
            if self.scale >= 1.2 then
                self.grow = false
            end
        else
            self.scale = self.scale - 0.1
            if self.scale <= 1 then
                self.grow = true
            end
        end
    end
end

function Cursor:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(self.lineWidth)

    -- Calculate scaled position to keep it centered
    local offset = (self.size * self.scale - self.size) / 2
    love.graphics.rectangle("line", self.x - offset, self.y - offset - 16, self.size * self.scale, self.size * self.scale)
    
    love.graphics.setLineWidth(1)  -- Reset line width to default
end

return Cursor