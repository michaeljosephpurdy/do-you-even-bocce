class("BaseMeter").extends(playdate.graphics.sprite)

function BaseMeter:init(player_x, player_y, starting_direction)
	BaseMeter.super.init(self)
	self:setZIndex(5000)
	self:setSize(400, 240)
	self:setCenter(0, 0)
	self:moveTo(0, 0)
	self.direction = starting_direction or 90
	self.radius = 30
	self.speed = 2
	self.arc_offset = 5
	self.arc_width = 10
	self.arc = playdate.geometry.arc.new(
		player_x,
		player_y,
		self.radius,
		self.direction - self.arc_offset,
		self.direction + self.arc_offset
	)
end

function BaseMeter:get_value()
	assert(nil, "BaseMeter.get_value must be overwritten in " .. self.className)
end
