-- crop.lua

local bump = require "libs.bump"

local Crop = {}
Crop.__index = Crop

function Crop:new(world, x, y)
    local obj = {
        x = x,
        y = y,
        width = 32,
        height = 32,
        state = "planted", -- other states: growing, ready
        growthTime = 0,
        waterNeeded = 3,
        watered = 0,
        world = world,
        color = {0, 1, 0}, -- Initial color (green)
        waterTimer = 0,
        waterDuration = 1 -- Duration for which the crop remains blue after watering
    }
    world:add(obj, x, y, obj.width, obj.height)
    setmetatable(obj, Crop)
    return obj
end

function Crop:water()
    if self.watered < self.waterNeeded then
        self.watered = self.watered + 1
        self.color = {0, 0, 1} -- Change color to blue
        self.waterTimer = self.waterDuration
    end
    if self.watered >= self.waterNeeded then
        self.state = "growing"
    end
end

function Crop:collect()
    if self.state == "ready" then
        self.state = "collected"
        self.world:remove(self) -- Remove crop from the physics world
        return true
    end
    return false
end

function Crop:update(dt)
    if self.state == "growing" then
        self.growthTime = self.growthTime + dt
        if self.growthTime >= 10 then -- Arbitrary growth time
            self.state = "ready"
        end
    end

    if self.waterTimer > 0 then
        self.waterTimer = self.waterTimer - dt
        if self.waterTimer <= 0 then
            self.color = {0, 1, 0} -- Revert color to green
        end
    end
end

function Crop:draw()
    if self.state ~= "collected" then
        love.graphics.setColor(self.color)
        if self.state == "ready" then
            love.graphics.setColor(1, 1, 0)
        end
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
end

return Crop
