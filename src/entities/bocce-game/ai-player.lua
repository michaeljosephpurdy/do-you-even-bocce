local timer <const> = playdate.timer
class("BocceAiPlayer").extends(BaseBoccePlayer)
BocceAiPlayer:implements(CalculateDirectThrowMixin)
BocceAiPlayer:implements(BallThrowingMixin)

function BocceAiPlayer:init(type, x, y, ball_type)
	BocceAiPlayer.super.init(self, type, ball_type)
	self:moveTo(x, y)
	self.offset = 15
	self:fix_draw_order()
end

function BocceAiPlayer:update()
	if not self.active then
		return
	end
	BocceAiPlayer.super.update(self)
	if self.thrown_ball then
		return
	end
end

function BocceAiPlayer:deactivate()
	BocceAiPlayer.super.deactivate(self)
	self.active = false
end

function BocceAiPlayer:activate()
	BocceAiPlayer.super.activate(self)
	self.in_game = true
	self.active = true
	self.thrown_ball = nil

	timer.performAfterDelay(math.random(500, 2000), function()
		local dir_x, dir_y, power, spin = self:calculate_direct_throw(self.offset)
		local jump_height = 0
		self.thrown_ball = self:throw_ball(self.x, self.y, dir_x, dir_y, power, spin, jump_height)
	end)
end

function BocceAiPlayer:is_done()
	return self.thrown_ball and self.thrown_ball:is_done()
end
