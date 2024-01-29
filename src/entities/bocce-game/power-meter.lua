local gfx <const> = playdate.graphics
class("PowerMeter").extends(BaseMeter)

PowerMeter.singleton = true

function PowerMeter:init(player_x, player_y, starting_direction, level_id)
	PowerMeter.super.init(self, player_x, player_y, 100, 100, starting_direction, level_id)
	self.starting_direction = starting_direction
	self.arc.startAngle = starting_direction
	self.arc.endAngle = starting_direction + 1
	self.min_power = 200
	self.max_power = 1200
	self.animation = playdate.graphics.animator.new(1500, 0, 1, playdate.easingFunctions.inOutBack)
	self.animation.s = 0
	self.animation.reverses = true
	self.animation.loops = true
end

function PowerMeter:update()
	self:markDirty()
	self.arc.endAngle = self.starting_direction + (self.animation:currentValue() * 359) + 1
	if self.animation:ended() then
		self.animation:reset()
	end
end

function PowerMeter:get_value()
	return self.min_power + (self.animation:currentValue() * (self.max_power - self.min_power))
end

function PowerMeter:draw()
	gfx.lockFocus(self.image)
	gfx.setLineWidth(self.arc_width)
	gfx.setColor(playdate.graphics.kColorXOR)
	gfx.drawArc(self.arc)
	gfx.unlockFocus()
end
