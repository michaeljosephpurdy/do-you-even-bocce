class("Player").extends(playdate.graphics.sprite)

local STATES = {
	INPUT_POSITION = "INPUT_POSITION",
	THROW = "THROW",
}
Player.STATES = STATES
function Player:init()
	Player.super.init(self)
	self:setImage(playdate.graphics.image.new("images/player"))
	self:moveTo(20, 20)
	self.state = STATES.INPUT_POSITION
end

function Player:update()
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		self:moveTo(self.x - 1, self.y)
	elseif playdate.buttonIsPressed(playdate.kButtonRight) then
		self:moveTo(self.x + 1, self.y)
	end
	if playdate.buttonIsPressed(playdate.kButtonUp) then
		self:moveTo(self.x, self.y - 1)
	elseif playdate.buttonIsPressed(playdate.kButtonDown) then
		self:moveTo(self.x, self.y + 1)
	end
	if playdate.buttonJustReleased(playdate.kButtonA) then
		SpriteManagerSingleton:add(WhiteBall(self.x, self.y))
	end
end
