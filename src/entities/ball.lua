class("Ball").extends(BaseEntity)
class("JackBall").extends(Ball)
class("WhiteBall").extends(Ball)
class("BlackBall").extends(Ball)
class("WhiteGrayBall").extends(Ball)
class("BlackGrayBall").extends(Ball)

function Ball:init(x, y, dir_x, dir_y, power, spin)
	Ball.super.init(self)
	self:setImage(playdate.graphics.image.new("images/ball"))
	self:moveTo(x or 0, y or 0)
	dir_x = 1 --math.random()
	dir_y = 1 --math.random()
	local velocity_vector = playdate.geometry.vector2D.new(dir_x or 1, dir_y or 1)
	velocity_vector:normalize()
	self.vel_x = velocity_vector.dx * (power or 20)
	self.vel_y = velocity_vector.dy * (power or 20)
	self.friction_x = 0.90
	self.friction_y = 0.90
	self.mass = 10
	self.radius = 16
	self:setCollideRect(2, 2, self.radius - 4, self.radius - 4)
end

function Ball:update()
	self.vel_x = self.vel_x * self.friction_x
	self.vel_y = self.vel_y * self.friction_y
	local x = self.x + self.vel_x
	local y = self.y + self.vel_y
	if self.vel_x <= 0.1 and self.vel_x >= -0.1 then
		self.vel_x = 0
	end
	if self.vel_y <= 0.1 and self.vel_y >= -0.1 then
		self.vel_y = 0
	end
	self:moveTo(x, y)
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
	self.vel_x = self.vel_x / 2
	self.vel_y = self.vel_y / 2
	other.vel_x = other.vel_x + self.vel_x
	other.vel_y = other.vel_y + self.vel_y
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
