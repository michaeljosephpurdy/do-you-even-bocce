class("OverworldControllablePlayer").extends(BasePlayer)
OverworldControllablePlayer.is_player = true

function OverworldControllablePlayer:init(x, y)
	OverworldControllablePlayer.super.init(self, BasePlayer.TYPES.MAIN)
	self:moveTo(x, y)
	self:setZIndex(2)
	self:setCollideRect(6, self.height - self.height / 4, self.width - 12, self.height / 4)
end

function OverworldControllablePlayer:update()
	OverworldControllablePlayer.super.update(self)
	local goal_x, goal_y = self.x, self.y
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		goal_x = goal_x - 2
	elseif playdate.buttonIsPressed(playdate.kButtonRight) then
		goal_x = goal_x + 2
	end
	if playdate.buttonIsPressed(playdate.kButtonUp) then
		goal_y = goal_y - 2
	elseif playdate.buttonIsPressed(playdate.kButtonDown) then
		goal_y = goal_y + 2
	end
	local actualX, actualY, collisions, numberOfCollisions = self:moveWithCollisions(goal_x, goal_y)

	CameraSingleton:target_sprite_centered(self, 5)
	for _, other in ipairs(self:overlappingSprites()) do
		self.target = other
	end
	if self.target and playdate.buttonJustReleased(playdate.kButtonA) then
		SceneManagerSingleton:next_state(BocceGameScene)
	end
	self.target = nil
end

function OverworldControllablePlayer:collides_with(other)
	other:collides_with(self)
end
