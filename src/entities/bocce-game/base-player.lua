class("BaseBoccePlayer").extends(BasePlayer)

function BaseBoccePlayer:init(player_type, ball_type)
	BaseBoccePlayer.super.init(self, player_type)
	self.ball_type = ball_type
	self.points = 0
end

function BaseBoccePlayer:update()
	self:fix_draw_order()
end

function BaseBoccePlayer:add_points(points)
	self.points = self.points + points
end

function BaseBoccePlayer:deactivate()
	self:setZIndex(self:getZIndex() - 1)
end

function BaseBoccePlayer:activate()
	self:setZIndex(self:getZIndex() + 1)
end

function BaseBoccePlayer:is_done()
	assert(nil, "BaseBoccePlayer:is_done must be overwritten")
end
