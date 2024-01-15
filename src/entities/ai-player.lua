local gfx <const> = playdate.graphics
local vector2D <const> = playdate.geometry.vector2D
local timer <const> = playdate.timer
class("AiPlayer").extends(BasePlayer)

function AiPlayer:init(name, ball_type)
	AiPlayer.super.init(self, name, ball_type)
	self:setImage(gfx.image.new("images/other-player-small"))
	self:moveTo(40, 132)
	self:setAlwaysRedraw(true)
	self.offset = 15
	self:fix_z_index()
end

function AiPlayer:update()
	if not self.active then
		return
	end
	AiPlayer.super.update(self)
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

function AiPlayer:deactivate()
	AiPlayer.super.deactivate(self)
	self.active = false
end

function AiPlayer:activate()
	AiPlayer.super.activate(self)
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

function AiPlayer:is_done()
	return self.thrown_ball and self.thrown_ball:is_done()
end
