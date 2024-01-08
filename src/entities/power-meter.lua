class("PowerMeter").extends(playdate.graphics.sprite)

PowerMeter.singleton = true

function PowerMeter:init()
	PowerMeter.super.init(self)
	self:setSize(400, 240)
	self:setCenter(0, 0)
	self:moveTo(0, 0)
	self:setAlwaysRedraw(true)
	self.min_power = 200
	self.max_power = 700
	self.animation = playdate.graphics.animator.new(1000, 0, 1, playdate.easingFunctions.inOutBack)
	self.animation.s = 0
	self.animation.reverses = true
	self.animation.loops = true
end

function PowerMeter:update()
	if self.animation:ended() then
		self.animation:reset()
	end
end

function PowerMeter:get_power()
	return self.min_power + (self.animation:currentValue() * (self.max_power - self.min_power))
end

function PowerMeter:draw(x, y, width, height)
	playdate.graphics.pushContext()
	playdate.graphics.drawRect(20, 200, 360, 20)
	playdate.graphics.fillRect(20, 200, self.animation:currentValue() * 360, 20)
	playdate.graphics.popContext()
end
