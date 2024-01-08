local gfx <const> = playdate.graphics
class("DirectionMeter").extends(playdate.graphics.sprite)

function DirectionMeter:init(player_x, player_y, starting_direction)
	DirectionMeter.super.init(self)
	self:setSize(100, 100)
	self:moveTo(player_x, player_y)
	self:setAlwaysRedraw(true)
	self.direction = starting_direction or 90
	self.radius = self.width / 3
	self.speed = 2
	self.arc_offset = 5
	self.arc =
		playdate.geometry.arc.new(0, 0, self.radius, self.direction - self.arc_offset, self.direction + self.arc_offset)
end

function DirectionMeter:update()
	if playdate.isCrankDocked() then
		self.direction = playdate.getCrankPosition()
	end
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		self.direction = self.direction - self.speed
	elseif playdate.buttonIsPressed(playdate.kButtonRight) then
		self.direction = self.direction + self.speed
	end
	self.arc.startAngle = self.direction - self.arc_offset
	self.arc.endAngle = self.direction + self.arc_offset
	-- wrap direction around
	if self.direction >= 360 then
		self.direction = 0
	elseif self.direction < 0 then
		self.direction = 359
	end
end

function DirectionMeter:get_direction()
	return playdate.geometry.vector2D.newPolar(10, self.direction)
end

function DirectionMeter:draw()
	if playdate.isCrankDocked() then
		playdate.ui.crankIndicator:draw()
	end
	gfx.pushContext(self:getImage())
	gfx.drawArc(self.arc)
	gfx.popContext()
end
