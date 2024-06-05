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

local world
local player
local enemy
local hud
local cursor
local gamePaused = false

function love.load()
    Basics:initGraphics({640, 480}, 'landscape', false, 3, false)

    world = bump.newWorld(32)  -- Adjusted world grid size to match player size
    player = Player:new(world, 320, 240)
    enemy = Enemy:new(world, 320-64, 240, player) -- Add an enemy
    hud = HUD:new(player)
    cursor = Cursor:new(world, 320, 240)
end

function love.update(dt)
    if not gamePaused then
        player:update(dt)
        enemy:update(dt) -- Update the enemy
        cursor:update(dt)

        if player.hp <= 0 then
            gamePaused = true
        end
    end
end

function love.draw()
    player:draw()
    enemy:draw() -- Draw the enemy
    cursor:draw()
    hud:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f4' then
        Basics.fullscreen()
    end
end

function love.keyreleased(key)
    -- Clear moveQueue on key released to prevent continuous movement when key is released
    if key == 'up' or key == 'down' or key == 'left' or 'right' then
        player.moveQueue = {}
    end
end
