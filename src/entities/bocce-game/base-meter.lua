class("BaseMeter").extends(playdate.graphics.sprite)

function BaseMeter:init(player_x, player_y, width, height, starting_direction, level_id)
	BaseMeter.super.init(self)
	self.level_id = level_id
	self:setZIndex(Z_INDEXES.METERS)
	self:setSize(width, height)
	self:moveTo(player_x, player_y)
	self.direction = starting_direction or 90
	self.radius = 30
	self.speed = 2
	self.arc_offset = 5
	self.arc_width = 10
	self.arc = playdate.geometry.arc.new(
		width / 2,
		height / 2,
		self.radius,
		self.direction - self.arc_offset,
		self.direction + self.arc_offset
	)
end

function BaseMeter:get_value()
	assert(nil, "BaseMeter.get_value must be overwritten in " .. self.className)
end
