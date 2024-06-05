love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setBackgroundColor(0, .3, .3)

Game = require("game")

-- Libraries
Basics = require("libs/basics")

local bump = require "libs.bump"

local Player = require "player"
local Enemy = require "enemy"
local HUD = require "hud"
local Cursor = require "cursor"
local Crop = require "crop"

local world
local player
local enemy
local hud
local cursor
local crops = {}
local collectedCrops = 0
local gamePaused = false

function love.load()
    Basics:initGraphics({640, 480}, 'landscape', false, 3, false)

    world = bump.newWorld(32)  -- Adjusted world grid size to match player size
    player = Player:new(world, 320, 240)
    enemy = Enemy:new(world, 320, 240+128, player) -- Add an enemy
    table.insert(crops, Crop:new(world, 320-64, 240-64))
    table.insert(crops, Crop:new(world, 320, 240-64))
    table.insert(crops, Crop:new(world, 320+64, 240-64))
    table.insert(crops, Crop:new(world, 320-64, 240))
    table.insert(crops, Crop:new(world, 320+64, 240))
    hud = HUD:new(player, crops, collectedCrops) -- Pass crops and collectedCrops to HUD
    cursor = Cursor:new(world, 320, 240)
end

function love.update(dt)
    if not gamePaused then
        player:update(dt)
        enemy:update(dt) -- Update the enemy
        cursor:update(dt)
        
        for i = #crops, 1, -1 do
            local crop = crops[i]
            crop:update(dt)
            if crop.state == "collected" then
                table.remove(crops, i)
            end
        end

        if player.hp <= 0 then
            gamePaused = true
        end
    end
end

function love.draw()
    player:draw()
    enemy:draw() -- Draw the enemy
    
    -- Draw all the crops
    for _, crop in ipairs(crops) do
        crop:draw()
    end

    -- Screen items
    cursor:draw()
    hud:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f4' then
        Basics.fullscreen()
    elseif key == 'z' then
        for _, crop in ipairs(crops) do
            -- Check if the player is near the crop
            local distance = math.sqrt((player.x - crop.x)^2 + (player.y - crop.y)^2)
            if distance < 50 then -- Arbitrary distance check
                if crop.state == "ready" then
                    if crop:collect() then
                        collectedCrops = collectedCrops + 1
                        hud:setCollectedCrops(collectedCrops) -- Update HUD
                    end
                else
                    crop:water()
                end
            end
        end
    end
end

function love.keyreleased(key)
    -- Clear moveQueue on key released to prevent continuous movement when key is released
    if key == 'up' or key == 'down' or key == 'left' or 'right' then
        player.moveQueue = {}
    end
end
