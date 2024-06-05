-- hud.lua

local HUD = {}
HUD.__index = HUD

function HUD:new(player, crops, collectedCrops)
    local obj = {
        player = player,
        crops = crops,
        collectedCrops = collectedCrops -- Store collectedCrops count
    }
    setmetatable(obj, HUD)
    return obj
end

function HUD:setCollectedCrops(count)
    self.collectedCrops = count
end

function HUD:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(Game.fonts.default)
    love.graphics.print("HP: " .. self.player.hp, 10, 10)
    love.graphics.print("Collected Crops: " .. self.collectedCrops, 10, 48) -- Display collected crops
    if self.player.hp <= 0 then
        love.graphics.setColor(1, 0, 0)
        love.graphics.setFont(Game.fonts.big)
        love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 2 - 24, love.graphics.getWidth(), "center")
    end
end

return HUD
