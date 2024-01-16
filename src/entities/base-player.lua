local gfx <const> = playdate.graphics
class("BasePlayer").extends(BaseEntity)

function BasePlayer:init(name, ball_type)
	BasePlayer.super.init(self)
	self.name = name
	self.ball_type = ball_type
	self.points = 0
end

function BasePlayer:update()
	self:fix_z_index()
end

function BasePlayer:deactivate()
	self:setZIndex(self:getZIndex() - 1)
end

function BasePlayer:activate()
	self:setZIndex(self:getZIndex() + 1)
end

function BasePlayer:is_done()
	assert(nil, "BasePlayer:is_done must be overwritten")
end

function BasePlayer:add_points(points)
	self.points = self.points + points
end
