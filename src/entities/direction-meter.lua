local gfx <const> = playdate.graphics
class("DirectionMeter").extends(BaseMeter)

function DirectionMeter:init(player_x, player_y, starting_direction)
	DirectionMeter.super.init(self, player_x, player_y, 100, 100, starting_direction)
	self.crank_indicator_time = 3
end

function DirectionMeter:update()
	self.old_direction = self.direction
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		self.direction = self.direction - self.speed
	elseif playdate.buttonIsPressed(playdate.kButtonRight) then
		self.direction = self.direction + self.speed
	elseif not playdate.isCrankDocked() and playdate.getCrankChange() ~= 0.0 then
		self.direction = playdate.getCrankPosition()
	end
	self.arc.startAngle = self.direction - self.arc_offset
	self.arc.endAngle = self.direction + self.arc_offset
	-- wrap direction around
	if self.direction >= 360 then
		self.direction = 0
	elseif self.direction < 0 then
		self.direction = 359
	end
	if self.direction ~= self.old_direction then
		self:markDirty()
	end
end

function DirectionMeter:get_value()
	return playdate.geometry.vector2D.newPolar(10, self.direction), self.direction
end

function DirectionMeter:draw()
	if playdate.isCrankDocked() and self.crank_indicator_time > 0 then
		self.crank_indicator_time = self.crank_indicator_time - DELTA_TIME
		playdate.ui.crankIndicator:draw()
	end
	gfx.pushContext()
	gfx.setLineWidth(self.arc_width)
	gfx.setColor(playdate.graphics.kColorXOR)
	gfx.drawArc(self.arc)
	gfx.popContext()
end
