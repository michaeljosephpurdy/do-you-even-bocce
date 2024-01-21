local gfx <const> = playdate.graphics
class("SpinMeter").extends(BaseMeter)

function SpinMeter:init(player_x, player_y, starting_direction)
	SpinMeter.super.init(self, player_x, player_y, 100, 100, starting_direction)
	self.overlay_arc = self.arc:copy()
	self.overlay_arc.startAngle = self.overlay_arc.startAngle - 1
	self.overlay_arc.endAngle = self.overlay_arc.endAngle + 1
	self.arc_offset = 4

	self.animation = playdate.graphics.animator.new(1500, 0, 1, playdate.easingFunctions.inOutBack)
	self.animation.s = 0
	self.animation.reverses = true
	self.animation.loops = true
end

function SpinMeter:update()
	self:markDirty()
	local offset = (self.animation:currentValue() - 0.5) * self.arc_offset
	self.arc.startAngle = self.arc.startAngle + offset
	self.arc.endAngle = self.arc.endAngle + offset
	if self.animation:ended() then
		self.animation:reset()
	end
end

function SpinMeter:get_value()
	return (self.animation:currentValue() - 0.5) * 2
end

function SpinMeter:draw()
	gfx.lockFocus(self.image)
	gfx.setLineWidth(self.arc_width)
	gfx.setColor(playdate.graphics.kColorXOR)
	gfx.drawArc(self.arc)
	gfx.setLineWidth(self.arc_width / 2)
	gfx.setColor(playdate.graphics.kColorXOR)
	gfx.drawArc(self.overlay_arc)
	gfx.unlockFocus()
end
