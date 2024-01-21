local lerp <const> = playdate.math.lerp
local setDrawOffset <const> = playdate.graphics.setDrawOffset

class("CameraSystem").extends()

function CameraSystem:init()
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

function CameraSystem:update()
	local old_x, old_y = self.x, self.y
	local new_x = self.target_x
	local new_y = self.target_y
	if new_x <= self.min_x then
		new_x = self.min_x
	elseif new_x >= self.max_x then
		new_x = self.max_x
	end
	if new_y <= self.min_y then
		new_y = self.min_y
	elseif new_y >= self.max_y then
		new_y = self.max_y
	end
	self.x = lerp(old_x, new_x, 3 * DELTA_TIME)
	self.y = lerp(old_y, new_y, 3 * DELTA_TIME)
	setDrawOffset(-self.x, -self.y)
end

function CameraSystem:target(x, y)
	self.target_x, self.target_y = x, y
end

function CameraSystem:target_centered(x, y)
	self.target_x, self.target_y = x - 200, y - 120
end
