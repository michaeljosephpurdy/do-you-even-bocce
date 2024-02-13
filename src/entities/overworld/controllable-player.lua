class("OverworldControllablePlayer").extends(BasePlayer)
OverworldControllablePlayer.is_player = true

function OverworldControllablePlayer:init(props)
	OverworldControllablePlayer.super.init(self, BasePlayer.TYPES.MAIN, props.level_id)
	local x, y = props.x, props.y
	self:setTag(COLLIDER_TAGS.PLAYER)
	self:moveTo(x, y)
	self:setZIndex(2)
	self:setCollideRect(6, self.height - self.height / 4, self.width - 12, self.height / 4)
end

function OverworldControllablePlayer:collisionResponse(other)
	local other_tag = other:getTag()
	if other_tag == COLLIDER_TAGS.OBSTACLE then
		return playdate.graphics.sprite.kCollisionTypeSlide
	end
	return playdate.graphics.sprite.kCollisionTypeOverlap
end

local function handle_movement(self)
	local goal_x, goal_y = self.x, self.y
	if not self.lock_controls then
		if playdate.buttonIsPressed(playdate.kButtonLeft) then
			goal_x = goal_x - 2
		elseif playdate.buttonIsPressed(playdate.kButtonRight) then
			goal_x = goal_x + 2
		elseif playdate.buttonIsPressed(playdate.kButtonUp) then
			goal_y = goal_y - 2
		elseif playdate.buttonIsPressed(playdate.kButtonDown) then
			goal_y = goal_y + 2
		end
	end
	local actual_x, actual_y, collisions, number_of_collisions = self:moveWithCollisions(goal_x, goal_y)
	for i = 1, number_of_collisions do
		local collision = collisions[i]
		local collided_sprite = collision.other
		local collision_tag = collided_sprite:getTag()
		if collision_tag == COLLIDER_TAGS.TRIGGER then
			self.target = collided_sprite
		end
	end
end

function OverworldControllablePlayer:add()
	OverworldControllablePlayer.lock_controls = false
	OverworldControllablePlayer.super.add(self)
end
function OverworldControllablePlayer:update()
	OverworldControllablePlayer.super.update(self)
	handle_movement(self)
	CameraSingleton:target_sprite_centered(self, 5)
	if self.target and playdate.buttonJustReleased(playdate.kButtonA) then
		self.target:trigger(self)
	end
	self.target = nil
end

function OverworldControllablePlayer:collides_with(other)
	other:collides_with(self)
end
