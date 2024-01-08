local gfx <const> = playdate.graphics
local vector2D <const> = playdate.geometry.vector2D

class("Ball").extends(BaseEntity)
class("JackBall").extends(Ball)
class("WhiteBall").extends(Ball)
class("BlackBall").extends(Ball)
class("WhiteGrayBall").extends(Ball)
class("BlackGrayBall").extends(Ball)

function Ball:init(x, y, dir_x, dir_y, power, spin)
	Ball.super.init(self)
	self:setImage(playdate.graphics.image.new("images/ball"))
	self.position = vector2D.new(x or 0, y or 0)
	local direction_vector = vector2D.new(dir_x, dir_y)
	direction_vector:normalize()
	self.velocity_vector = direction_vector * power

	self.friction = 0.90
	self.mass = 10
	self.radius = 8
	self:setCollideRect(0, 0, self:getSize())
end

function Ball:update()
	self.velocity_vector = self.velocity_vector * self.friction
	self.position = self.position + self.velocity_vector
	self:moveTo(self.position.x, self.position.y)
	local others = self:overlappingSprites()
	for _, other in pairs(others) do
		if self:check_collision(other) then
			self:collides_with(other)
		end
	end
end

function Ball:check_collision(other)
	if not other:isa(Ball) then
		return false
	end
	local max_distance = self.radius + other.radius
	local distance_squared = (other.x - self.x) * (other.x - self.x) + (other.y - self.y) * (other.y - self.y)
	return distance_squared <= max_distance * max_distance
end

function Ball:collides_with(other)
	local velocity_difference = other.velocity_vector - self.velocity_vector
	local position_difference = other.position - self.position

	local dot_product = velocity_difference:dotProduct(position_difference)
	local impulse = (2 * dot_product) / (self.mass + other.mass)

	position_difference:normalize()

	self.velocity_vector = self.velocity_vector + position_difference * impulse * self.mass
	other.velocity_vector = other.velocity_vector - position_difference * impulse * other.mass
end

function JackBall:init(x, y, dir_x, dir_y, power, spin)
	JackBall.super.init(self, x, y, dir_x, dir_y, power, spin)
	self:setImage(playdate.graphics.image.new("images/ball-jack"))
	self.mass = 8
	self.radius = 4
	self:setCollideRect(0, 0, self:getSize())
end
function WhiteBall:init(x, y, dir_x, dir_y, power, spin)
	WhiteBall.super.init(self, x, y, dir_x, dir_y, power, spin)
	self:setImage(playdate.graphics.image.new("images/ball-white"))
end
function BlackBall:init(x, y, dir_x, dir_y, power, spin)
	BlackBall.super.init(self, x, y, dir_x, dir_y, power, spin)
	self:setImage(playdate.graphics.image.new("images/ball-black"))
end
