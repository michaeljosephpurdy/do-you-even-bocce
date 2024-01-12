local gfx <const> = playdate.graphics
local vector2D <const> = playdate.geometry.vector2D
local zero_vector = vector2D.new(0, 0)

class("Ball").extends(BaseEntity)
class("JackBall").extends(Ball)
class("WhiteBall").extends(Ball)
class("BlackBall").extends(Ball)
class("WhiteGrayBall").extends(Ball)
class("BlackGrayBall").extends(Ball)
class("BallTrail").extends(BaseEntity)
function BallTrail:init(x, y)
	BallTrail.super.init(self)
	self:setSize(3, 3)
	--self:setAlwaysRedraw(true)
	self:moveTo(x, y)
	self.draw = function(self)
		print("ball trail draw")
		gfx.pushContext()
		gfx.setColor(playdate.graphics.kColorBlack)
		gfx.drawPixel(0, 0)
		gfx.popContext()
	end
end

function Ball:init(x, y, dir_x, dir_y, power, spin)
	Ball.super.init(self)
	self:setImage(gfx.image.new("images/ball"))
	self.position = vector2D.new(x or 0, y or 0)
	self:moveTo(self.position.x, self.position.y)
	local direction_vector = vector2D.new(dir_x or 0, dir_y or 0)
	direction_vector:normalize()
	self.velocity_vector = direction_vector * (power or 0) / 2

	local spin_angle = math.atan2(direction_vector.y, direction_vector.x) + math.rad(90)
	self.spin_vector = vector2D.newPolar(1, spin_angle)
	local spin_power = (spin or 0) * 400
	if spin_power ~= 0 then
		self.spin_animation = playdate.graphics.animator.new(1000, -spin_power / 2, spin_power / 2)
		-- self.spin = spin or 0
		-- self.spin_timer = playdate.timer.new(500, 0, self.spin * 400, playdate.easingFunctions.inCubic)
		-- self.spin_timer.s = 0
		-- self.spin_amount = self.spin * 400
		-- self.accumulated_spin = 0
		-- self.spin_modifier = self.friction
	end

	self.friction = 0.94
	self.friction_vector = vector2D.new(self.friction, self.friction)
	self.mass = 10
	self.radius = 6
	self:setCollideRect(0, 0, self:getSize())
	self.trail = {}
end

function Ball:update()
	local spin = zero_vector
	if self.spin_animation and not self.spin_animation:ended() then
		spin = self.spin_vector * self.spin_animation:currentValue()
	end
	self.velocity_vector = self.velocity_vector * self.friction
	if self.velocity_vector:magnitude() < 0.01 then
		self.velocity_vector = zero_vector
		spin = zero_vector
	else
		--SpriteManagerSingleton:add(BallTrail(self.x, self.y))
	end
	self.position = self.position + ((self.velocity_vector + spin) * DELTA_TIME)
	self:moveTo(self.position.x, self.position.y)
	local others = self:overlappingSprites()
	for _, other in pairs(others) do
		if self:check_collision_with_ball(other) then
			self:collide_with_ball(other)
		end
	end
end

function Ball:check_collision_with_ball(other)
	if not other:isa(Ball) then
		return false
	end
	local max_distance = self.radius + other.radius
	local distance_squared = (other.x - self.x) * (other.x - self.x) + (other.y - self.y) * (other.y - self.y)
	return distance_squared <= max_distance * max_distance
end

function Ball:collide_with_ball(other)
	local velocity_difference = other.velocity_vector - self.velocity_vector
	local position_difference = other.position - self.position
	position_difference:normalize()

	local dot_product = velocity_difference:dotProduct(position_difference)
	local impulse = (2 * dot_product) / (self.mass + other.mass)

	self.velocity_vector = self.velocity_vector + position_difference * impulse * self.mass * self.friction
	other.velocity_vector = other.velocity_vector - position_difference * impulse * other.mass * other.friction
end

function JackBall:init(x, y)
	JackBall.super.init(self, x, y)
	self:setImage(gfx.image.new("images/ball-jack"))
	self.mass = 8
	self.radius = 3
	self.friction = 0
	self:setCollideRect(0, 0, self:getSize())
end

function WhiteBall:init(x, y, dir_x, dir_y, power, spin)
	WhiteBall.super.init(self, x, y, dir_x, dir_y, power, spin)
	self:setImage(gfx.image.new("images/ball-white"))
end
function BlackBall:init(x, y, dir_x, dir_y, power, spin)
	BlackBall.super.init(self, x, y, dir_x, dir_y, power, spin)
	self:setImage(gfx.image.new("images/ball-black"))
end
