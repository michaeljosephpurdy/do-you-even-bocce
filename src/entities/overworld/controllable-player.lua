class("OverworldControllablePlayer").extends(BasePlayer)

function OverworldControllablePlayer:init(x, y)
	OverworldControllablePlayer.super.init(self, BasePlayer.TYPES.MAIN)
	self:moveTo(x, y)
	self:setZIndex(2)
	self:setCollideRect(-8, 0, self.width + 16, self.height)
end

function OverworldControllablePlayer:update()
	OverworldControllablePlayer.super.update(self)
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		local new_x = self.x - 2
		self:moveTo(new_x, self.y)
	elseif playdate.buttonIsPressed(playdate.kButtonRight) then
		local new_x = self.x + 2
		self:moveTo(new_x, self.y)
	end
	if playdate.buttonIsPressed(playdate.kButtonUp) then
		local new_y = self.y - 2
		self:moveTo(self.x, new_y)
	elseif playdate.buttonIsPressed(playdate.kButtonDown) then
		local new_y = self.y + 2
		self:moveTo(self.x, new_y)
	end
	for _, other in ipairs(self:overlappingSprites()) do
		self.target = other
	end
	if self.target and playdate.buttonJustReleased(playdate.kButtonA) then
		print("here")
		SceneManagerSingleton:next_state(BocceGameScene)
	end
	self.target = nil
end

function OverworldControllablePlayer:collides_with(other)
	other:collides_with(self)
end
