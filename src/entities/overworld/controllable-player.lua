class("OverworldControllablePlayer").extends(BasePlayer)
OverworldControllablePlayer.is_player = true

function OverworldControllablePlayer:init(props)
	OverworldControllablePlayer.super.init(self, BasePlayer.TYPES.MAIN, props.level_id)
	local x, y = props.x, props.y
	self:setTag(COLLIDER_TAGS.PLAYER)
	self:setGroups({ COLLIDER_TAGS.PLAYER })
	self:setCollidesWithGroups({ COLLIDER_TAGS.OBSTACLE, COLLIDER_TAGS.TRIGGER })
	self:moveTo(x, y)
	self:setZIndex(2)
	self:setCollideRect(6, self.height - self.height / 4, self.width - 12, self.height / 4)
	CameraSingleton:target_sprite_centered(self, 5)
	self.speed = 3
	self.background_detector = BackgroundDetector(self)
end

function OverworldControllablePlayer:collisionResponse(other)
	local other_tag = other:getTag()
	if other_tag == COLLIDER_TAGS.OBSTACLE then
		return playdate.graphics.sprite.kCollisionTypeSlide
	end
	return playdate.graphics.sprite.kCollisionTypeOverlap
end

local function handle_movement(self)
	local old_x, old_y = self.x, self.y
	local goal_x, goal_y = self.x, self.y
	if not self.lock_controls then
		if playdate.buttonIsPressed(playdate.kButtonLeft) then
			goal_x = goal_x - self.speed
		elseif playdate.buttonIsPressed(playdate.kButtonRight) then
			goal_x = goal_x + self.speed
		elseif playdate.buttonIsPressed(playdate.kButtonUp) then
			goal_y = goal_y - self.speed
		elseif playdate.buttonIsPressed(playdate.kButtonDown) then
			goal_y = goal_y + self.speed
		end
	end
	if old_x == goal_x and old_y == goal_y then
		return false
	end
	local actual_x, actual_y, collisions, number_of_collisions = self:moveWithCollisions(goal_x, goal_y)
	self.target = nil
	self.new_level_id = nil
	self.active_level_id = nil
	self.levels = {}
	for i = 1, number_of_collisions do
		local collision = collisions[i]
		local collided_sprite = collision.other
		local collision_tag = collided_sprite:getTag()
		if collision_tag == COLLIDER_TAGS.TRIGGER then
			self.target = collided_sprite
		end
	end
	-- did the player move?
	return old_x ~= self.x or old_y ~= self.y
end

function OverworldControllablePlayer:add()
	OverworldControllablePlayer.lock_controls = false
	OverworldControllablePlayer.super.add(self)
	self.background_detector:add()
end

function OverworldControllablePlayer:update()
	OverworldControllablePlayer.super.update(self)
	local moved = handle_movement(self)
	if moved then
		CameraSingleton:target_sprite_centered(self, 5)
		if self.new_level_id and not self.active_level_id and self.new_level_id ~= self.level_id then
			local old_level_id = self.level_id
			self.level_id = self.new_level_id
			self.active_level_id = self.new_level_id
			WorldLoaderSingleton:load(self.new_level_id)
			print("loaded")
			SpriteManagerSingleton:purge_level(old_level_id)
		end
	end
	if not self.lock_controls and self.target and playdate.buttonJustReleased(playdate.kButtonA) then
		self.target:trigger(self)
	end
end

function OverworldControllablePlayer:transition(level_id, x, y)
	self.level_id = level_id
	self:moveTo(x, y)
	self.target = nil
	CameraSingleton:target_sprite_centered(self, 0)
	CameraSingleton:target_sprite_centered(self, 5)
end

function OverworldControllablePlayer:remove()
	OverworldControllablePlayer.super.remove(self)
	self.background_detector:remove()
end

function OverworldControllablePlayer:collides_with(other)
	other:collides_with(self)
end
