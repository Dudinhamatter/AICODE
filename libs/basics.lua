-- This is a library for basics functions that most games uses
local Basics = {}

local Camera = require("libs/camera")

function Basics:initGraphics(resolution,screen_orientation,android,gamescale,camera,smoother) -- initialize basic graphics configurations
	GameResolution = {w=resolution[1],h=resolution[2]}
	self.isAndroid = android
	if screen_orientation=='portrait' then
		if android then
			love.window.setMode(1,2)
		end
		ScreenHeight,ScreenWidth=love.graphics.getDimensions()
	else
		if android then
			love.window.setMode(2,1)
		end
		ScreenWidth,ScreenHeight=love.graphics.getDimensions()
	end
	
	if Game.fonts~=nil then
		love.graphics.setFont(Game.fonts.default)
	end
	
	-- Camera and zoom
	GameScale = gamescale or 1
	if camera then
		Cam = Camera(0,0,GameScale)
		Cam.smoother = Camera.smooth.damped(smoother or 15)
	end
end

function Basics.updateScreenDimensions()
	if screen_orientation=='portrait' then
		ScreenHeight,ScreenWidth=love.graphics.getDimensions()
	else
		ScreenWidth,ScreenHeight=love.graphics.getDimensions()
	end
end

function Basics.fullscreen()
	love.window.setMode(GameResolution.w,GameResolution.h,{fullscreen=not love.window.getFullscreen()})
	Basics.updateScreenDimensions()
end

function Basics:checkGamepad()
	if love.joystick.getJoysticks()[1]==nil then
    isUsingGamepad = false
  else
    isUsingGamepad = true
  end
end

function Basics.showBumpCollisions()
	love.graphics.setColor(1,0,1,0.3)
	local items, len = World:getItems()
	for i=1, len do
		local x,y,w,h = World:getRect(items[i])
		love.graphics.rectangle("fill",x,y,w,h)
	end
	love.graphics.setColor(1,1,1,1)
end

function Basics.moveInDirection(direction,discrepancy)
	local d = discrepancy or 0
	return {x=math.cos(direction-math.rad(d)),y=math.sin(direction-math.rad(d))}
end

function Basics.lookAt(pos_a,pos_b, discrepancy)
	local d = discrepancy or 0
	return math.atan2((pos_b.y-pos_a.y),(pos_b.x-pos_a.x))+math.rad(math.random(-d,d))
end

function Basics:moveTowards(pos_a,pos_b,discrepancy)
	return self.moveInDirection(self.lookAt(pos_a,pos_b,discrepancy),discrepancy)
end


function Basics.outlineText(font,text,textcolor,outline,outlinecolor,x,y,limit,center,scale)
  if outlinecolor ~= nil then
    love.graphics.setColor(love.math.colorFromBytes(unpack(outlinecolor)))
  else
    love.graphics.setColor(0,0,0,1)
  end
  local X = x-limit/2*scale+3
  if font~=nil then
    love.graphics.setFont(font)
  end
  love.graphics.printf(text,X-outline,y,limit,center,nil,scale,scale)
  love.graphics.printf(text,X+outline,y,limit,center,nil,scale,scale)
  love.graphics.printf(text,X,y-outline,limit,center,nil,scale,scale)
  love.graphics.printf(text,X,y+outline,limit,center,nil,scale,scale)
  
  if textcolor ~= nil then
    love.graphics.setColor(love.math.colorFromBytes(unpack(textcolor)))
  else
    love.graphics.setColor(1,1,1,1)
  end
  love.graphics.printf(text,X,y,limit,center,nil,scale,scale)
  
  love.graphics.setFont(Game.fonts.default)
  
  love.graphics.setColor(1,1,1,1)
end

function printConsole(txt,order)
  love.graphics.setNewFont(8)
  love.graphics.setColor(0.5,0.8,0.5,0.5)
  love.graphics.printf(txt,ScreenWidth-225,(ScreenHeight-20)-10*order-5*order,220,"right",nil,1,1)
  love.graphics.setColor(1,1,1,1)
end

return Basics