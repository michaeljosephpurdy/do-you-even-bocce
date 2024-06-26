local lerp <const> = playdate.math.lerp
local setDrawOffset <const> = playdate.graphics.setDrawOffset

class("CameraSystem").extends()

function CameraSystem:init()
	self.lerp_factor = 1
	self.x = 0
	self.y = 0
	self.target_x = 0
	self.target_y = 0
	self.min_x = 0
	self.min_y = 0
	self.max_x = 0
	self.max_y = 0
	WorldLoaderSingleton:subscribe(WorldLoaderSystem.EVENTS.LOAD_LEVEL, function(payload)
		self.min_x = payload.x
		self.max_x = payload.xx
		self.min_y = payload.y
		self.max_y = payload.yy
	end)
end

function CameraSystem:set_boundaries(x, xx, y, yy)
	self.min_x = x
	self.max_x = xx
	self.min_y = y
	self.max_y = yy
end

function CameraSystem:update()
	local old_x, old_y = self.x, self.y
	local new_x = self.target_x
	local new_y = self.target_y
	if new_x <= self.min_x then
		new_x = self.min_x
	elseif new_x >= self.max_x - 400 then
		new_x = self.max_x - 400
	end
	if new_y <= self.min_y then
		new_y = self.min_y
	elseif new_y >= self.max_y - 240 then
		new_y = self.max_y - 240
	end
	self.x = lerp(old_x, new_x, self.lerp_factor * DELTA_TIME)
	self.y = lerp(old_y, new_y, self.lerp_factor * DELTA_TIME)
	setDrawOffset(-self.x, -self.y)
end

function CameraSystem:target(x, y, lerp_factor)
	self.lerp_factor = lerp_factor or 3
	if self.lerp_factor == 0 then
		self.x, self.y = x, y
	end
	self.target_x, self.target_y = x, y
end

function CameraSystem:target_centered(x, y, lerp_factor)
	self:target(x - 200, y - 120, lerp_factor)
end

function CameraSystem:target_sprite_centered(sprite, lerp_factor)
	self:target_centered(sprite.x, sprite.y, lerp_factor)
end

function CameraSystem:target_between_sprites_centered(sprite, other_sprite, lerp_factor)
	local diff_x = sprite.x + (other_sprite.x - sprite.x) / 2
	local diff_y = sprite.y + (other_sprite.y - sprite.y) / 2
	self:target_centered(diff_x, diff_y, lerp_factor)
end
