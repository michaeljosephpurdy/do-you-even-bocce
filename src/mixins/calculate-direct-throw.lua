local function calculate_direction(self, offset)
	local self_vector = vector2D.new(self.x, self.y)
	local jack_ball_vector = vector2D.new(self.jack_ball.x, self.jack_ball.y)
	local offset_vector = vector2D.new(math.random(-offset * 2, offset * 2), math.random(-offset * 2, offset * 2))
	local difference = jack_ball_vector - self_vector + offset_vector
	local angle = math.deg(math.atan(difference.y, difference.x)) + 90
	local direction_vector = vector2D.newPolar(10, angle)
	direction_vector:normalize()
	return direction_vector:unpack()
end

local function calculate_power(self, offset)
	local self_vector = vector2D.new(self.x, self.y)
	local jack_ball_vector = vector2D.new(self.jack_ball.x, self.jack_ball.y)
	local offset_vector = vector2D.new(math.random(-offset * 2, offset * 2), math.random(-offset * 2, offset * 2))
	local difference = jack_ball_vector - self_vector + offset_vector
	return difference:magnitude() * 4
end

function CalculateDirectThrowMixin:calculate_direct_throw(offset)
	local dir_x, dir_y = calculate_direction(self, offset)
	local power = calculate_power(self, offset)
	local spin = 0
	return dir_x, dir_y, power, spin
end
