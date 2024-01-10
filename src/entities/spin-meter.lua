local gfx <const> = playdate.graphics
class("SpinMeter").extends(BaseMeter)

function SpinMeter:init(player_x, player_y, starting_direction)
	SpinMeter.super.init(self, player_x, player_y, starting_direction)
	self:setAlwaysRedraw(true)
	self.overlay_arc = self.arc:copy()
	self.overlay_arc.startAngle = self.overlay_arc.startAngle - 1
	self.overlay_arc.endAngle = self.overlay_arc.endAngle + 1

	self.arc_sway_distance = 2
	self.animation = playdate.graphics.animator.new(
		1500,
		-self.arc_sway_distance,
		self.arc_sway_distance,
		playdate.easingFunctions.inOutBack
	)
	self.animation.s = 0
	self.animation.reverses = true
	self.animation.loops = true
end

function SpinMeter:update()
	local arc_offset = self.animation:currentValue()
	self.arc.startAngle = self.arc.startAngle + arc_offset
	self.arc.endAngle = self.arc.endAngle + arc_offset
	if self.animation:ended() then
		self.animation:reset()
	end
end

function SpinMeter:get_value()
	return self.animation:currentValue()
end

function SpinMeter:draw()
	gfx.pushContext()
	gfx.setLineWidth(self.arc_width)
	gfx.setColor(playdate.graphics.kColorXOR)
	gfx.drawArc(self.arc)
	gfx.setLineWidth(self.arc_width / 2)
	gfx.setColor(playdate.graphics.kColorXOR)
	gfx.drawArc(self.overlay_arc)
	gfx.popContext()
end
