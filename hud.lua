-- hud.lua

local HUD = {}
HUD.__index = HUD

function HUD:new(player)
    local obj = {
        player = player
    }
    setmetatable(obj, HUD)
    return obj
end

function HUD:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("HP: " .. self.player.hp, 10, 10)
    if self.player.hp <= 0 then
        love.graphics.setColor(1, 0, 0)
        love.graphics.setFont(love.graphics.newFont(48))
        love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 2 - 24, love.graphics.getWidth(), "center")
    end
end

return HUD
