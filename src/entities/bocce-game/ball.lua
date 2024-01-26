local gfx <const> = playdate.graphics
local vector2D <const> = playdate.geometry.vector2D
local zero_vector = vector2D.new(0, 0)

class("Ball").extends(BaseEntity)
class("JackBall").extends(Ball)
class("WhiteBall").extends(Ball)
class("BlackBall").extends(Ball)
class("WhiteGrayBall").extends(Ball)
class("BlackGrayBall").extends(Ball)

function Ball:init(x, y, radius, props)
	Ball.super.init(self)
	self:setTag(COLLIDER_TAGS.BALL)
	self.radius = radius
	self.diameter = self.radius * 2
	self.shadow_offset = self.radius / 3
	for k, v in pairs(props or {}) do
		self[k] = v
	end
	self:setCenter(0.5, 0.8)
	self:setSize(self.radius * 8, self.radius * 8)
	self.position = vector2D.new(x or 0, y or 0)
	self:moveTo(self.position.x, self.position.y)
	self.ball_x, self.ball_y = self.x, self.y

	local direction_vector = vector2D.new(self.dir_x or 0, self.dir_y or 0)
	direction_vector:normalize()
	self.velocity_vector = direction_vector * (self.power or 0) / 2

	self.friction = 0.94
	self.friction_vector = vector2D.new(self.friction, self.friction)
	self.mass = 10
	-- collider rect is a bit wild right now
	-- we can't just use x, y, width, height, since the ball is now in the bottom
	-- of the sprite, and when it has air time it is just displayed further up
	-- within the sprite.
	-- Because of this, we need to manually define the collider rect.
	-- When we do, we want to use variables that depend on the radius
	-- passed in, like diameter and shadow_offset
	self:setCollideRect(
		self.width - self.diameter - self.diameter + self.shadow_offset,
		self.height - self.diameter + self.shadow_offset + self.shadow_offset,
		self.diameter - self.shadow_offset - self.shadow_offset,
		self.diameter - self.shadow_offset - self.shadow_offset - self.shadow_offset
	)

	self.jump = self.jump or 0
	self.z = self.jump / 2
	self.gravity = 5

	-- TODO: get spin to work
	local spin_angle = math.atan(direction_vector.y, direction_vector.x) + math.rad(90)
	self.spin_vector = vector2D.newPolar(1, spin_angle)
	self.spin = zero_vector
end

function Ball:collisionResponse(other)
	local other_tag = other:getTag()
	if other_tag == COLLIDER_TAGS.OBSTACLE then
		return playdate.graphics.sprite.kCollisionTypeBounce
	elseif other_tag == COLLIDER_TAGS.BALL then
		return playdate.graphics.sprite.kCollisionTypeBounce
	end
	return playdate.graphics.sprite.kCollisionTypeOverlap
end

function Ball:update()
	-- if ball is close to stopping, just stop it now
	if
		(self.velocity_vector.x <= 0.5 and self.velocity_vector.x >= -0.5)
		and (self.velocity_vector.y <= 0.5 and self.velocity_vector.y >= -0.5)
	then
		self.velocity_vector = zero_vector
	end
	self:fix_draw_order()
	self.jump = self.jump - self.gravity
	self.z = self.z + (self.jump * DELTA_TIME)
	if self.z <= 0 then
		self.z = 0
	end
	self.velocity_vector = self.velocity_vector * self.friction
	self.position = self.position + ((self.velocity_vector + self.spin) * DELTA_TIME)
	local actual_x, actual_y, collisions, number_of_collisions =
		self:moveWithCollisions(self.position.x, self.position.y)
	self.position.x = actual_x
	self.position.y = actual_y
	self.ball_x = self.x + self.width / 2
	self.ball_y = self.y + self.height - self.diameter
	for i = 1, number_of_collisions do
		print("collision")
		local collision = collisions[i]
		local collided_sprite = collision.other
		local collision_normal = collision.normal
		local collision_tag = collided_sprite:getTag()
		print("collision")
		if collision_tag == COLLIDER_TAGS.BALL then
			self:collides_with(collided_sprite)
		elseif collision_tag == COLLIDER_TAGS.OBSTACLE then
			if collision_normal.x ~= 0 then
				self.velocity_vector.x = self.velocity_vector.x * collision_normal.x * self.friction
			end
			if collision_normal.y ~= 0 then
				self.velocity_vector.y = self.velocity_vector.y * collision_normal.y * self.friction
			end
			return
		end
	end
end

function Ball:draw()
	gfx.lockFocus(self.image)
	-- draw shadow
	gfx.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
	local height_offset = self.z / 4
	gfx.fillEllipseInRect(
		self.width / 2 + 2 + height_offset,
		self.height - self.radius,
		self.diameter - 4 - height_offset - height_offset,
		self.diameter / 2 - height_offset
	)
	-- draw ball
	gfx.setColor(self.base_color)
	if self.fill_pattern then
		gfx.setPattern(self.fill_pattern)
	end
	if self.dither_pattern and self.dither_type then
		gfx.setDitherPattern(self.dither_pattern, self.dither_type)
	end
	gfx.fillCircleInRect(
		self.width / 2 - height_offset,
		self.height - self.diameter - self.shadow_offset - self.z,
		self.diameter + height_offset + height_offset,
		self.diameter + height_offset + height_offset
	)
	-- draw border
	gfx.setColor(self.border_color)
	gfx.drawCircleInRect(
		self.width / 2 - height_offset,
		self.height - self.diameter - self.shadow_offset - self.z,
		self.diameter + height_offset + height_offset,
		self.diameter + height_offset + height_offset
	)
	gfx.unlockFocus()
	gfx.setColor(gfx.kColorBlack)
	gfx.drawCircleAtPoint(self.ball_x, self.ball_y, 2)
end

function Ball:is_done()
	return self.velocity_vector.x == 0 and self.velocity_vector.y == 0
end

function Ball:collides_with(other)
	if self:check_collision_with_ball(other) then
		self:collide_with_ball(other)
	end
end

function Ball:check_collision_with_ball(other)
	local max_distance = self.radius + other.radius
	local distance_squared = (other.ball_x - self.ball_x) * (other.ball_x - self.ball_x)
		+ (other.ball_y - self.ball_y) * (other.ball_y - self.ball_y)
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
	JackBall.super.init(self, x, y, 6, {
		base_color = gfx.kColorBlack,
		border_color = gfx.kColorBlack,
		dither_pattern = 0.25,
		dither_type = gfx.image.kDitherTypeDiagonalLine,
	})
	self.mass = 8
	self.friction = 0.75
end

function WhiteBall:init(x, y, dir_x, dir_y, power, spin, height)
	WhiteBall.super.init(self, x, y, 8, {
		dir_x = dir_x,
		dir_y = dir_y,
		power = power,
		spin = spin,
		jump = height,
		base_color = gfx.kColorWhite,
		border_color = gfx.kColorBlack,
		fill_pattern = {},
	})
end

function BlackBall:init(x, y, dir_x, dir_y, power, spin, height)
	BlackBall.super.init(self, x, y, 8, {
		dir_x = dir_x,
		dir_y = dir_y,
		power = power,
		spin = spin,
		jump = height,
		base_color = gfx.kColorBlack,
		border_color = gfx.kColorBlack,
		fill_pattern = { 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 },
	})
end
