class("BallThrowingMixin").extends()

function BallThrowingMixin:throw_ball(x, y, dir_x, dir_y, power, spin, jump_height)
	assert(self.ball_type)
	local thrown_ball = self.ball_type(x, y, dir_x, dir_y, power, spin, jump_height)
	thrown_ball.player = self
	SpriteManagerSingleton:add(thrown_ball)
	if self.on_throw then
		self.on_throw(thrown_ball)
	end
	return thrown_ball
end
