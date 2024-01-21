local vector2D <const> = playdate.geometry.vector2D
local timer <const> = playdate.timer
class("BocceAiPlayer").extends(BaseBoccePlayer)

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

function calculate_direction(self)
	local self_vector = vector2D.new(self.x, self.y)
	local jack_ball_vector = vector2D.new(self.jack_ball.x, self.jack_ball.y)
	local offset_vector =
		vector2D.new(math.random(-self.offset * 2, self.offset * 2), math.random(-self.offset * 2, self.offset * 2))
	local difference = jack_ball_vector - self_vector + offset_vector
	local angle = math.deg(math.atan(difference.y, difference.x)) + 90
	local direction_vector = vector2D.newPolar(10, angle)
	direction_vector:normalize()
	return direction_vector:unpack()
end

function calculate_power(self)
	local self_vector = vector2D.new(self.x, self.y)
	local jack_ball_vector = vector2D.new(self.jack_ball.x, self.jack_ball.y)
	local offset_vector =
		vector2D.new(math.random(-self.offset * 2, self.offset * 2), math.random(-self.offset * 2, self.offset * 2))
	local difference = jack_ball_vector - self_vector + offset_vector
	return difference:magnitude() * 4
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
		local dir_x, dir_y = calculate_direction(self)
		local power = calculate_power(self)
		local spin = 0
		self.thrown_ball = self.ball_type(self.x, self.y, dir_x, dir_y, power, spin)
		self.thrown_ball.player = self
		SpriteManagerSingleton:add(self.thrown_ball)
		self.on_throw(self.thrown_ball)
	end)
end

function BocceAiPlayer:is_done()
	return self.thrown_ball and self.thrown_ball:is_done()
end
