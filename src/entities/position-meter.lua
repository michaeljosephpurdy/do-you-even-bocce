local gfx <const> = playdate.graphics
class("PositionMeter").extends(BaseMeter)

function PositionMeter:init(player_x, player_y, player)
	PositionMeter.super.init(self, player_x, player_y, 0)
	self:setAlwaysRedraw(true)
	self.radius = 50
	self.start_x, self.start_y = player_x, player_y
	self:setZIndex(player:getZIndex() - 1)
	self.arcs = {
		self.arc:copy(),
		self.arc:copy(),
		self.arc:copy(),
		self.arc:copy(),
		self.arc:copy(),
		self.arc:copy(),
		self.arc:copy(),
		self.arc:copy(),
		self.arc:copy(),
		self.arc:copy(),
	}
	for i, arc in ipairs(self.arcs) do
		arc.radius = self.radius
		arc.startAngle = i * (360 / #self.arcs) - 5
		arc.endAngle = i * (360 / #self.arcs) + 5
	end
end

function PositionMeter:update()
	for _, arc in pairs(self.arcs) do
		arc.startAngle = arc.startAngle + 1
		arc.endAngle = arc.endAngle + 1
	end
end

function PositionMeter:is_in_bounds(x, y)
	local max_distance = self.radius + 1
	local distance_squared = (x - self.start_x) * (x - self.start_x) + (y - self.start_y) * (y - self.start_y)
	return distance_squared <= max_distance * max_distance
end

function PositionMeter:draw()
	gfx.pushContext()
	gfx.setLineWidth(self.arc_width)
	gfx.setColor(playdate.graphics.kColorXOR)
	for _, arc in pairs(self.arcs) do
		gfx.drawArc(arc)
	end
	gfx.popContext()
end
