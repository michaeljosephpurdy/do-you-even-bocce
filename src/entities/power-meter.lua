class("PowerMeter").extends(playdate.graphics.sprite)

PowerMeter.singleton = true

function PowerMeter:init()
	PowerMeter.super.init(self)
	self:setSize(400, 240)
	self:moveTo(0, 0)
	self:setAlwaysRedraw(true)
end

function PowerMeter:draw(x, y, width, height)
	print("powermeter draw")
	print(x)
	print(y)
	print(width)
	print(height)
	playdate.graphics.pushContext()
	playdate.graphics.drawText("power meter!", 0, 0)
	playdate.graphics.popContext()
end
