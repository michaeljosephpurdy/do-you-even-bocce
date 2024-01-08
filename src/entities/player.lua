class("Player").extends(playdate.graphics.sprite)

local STATES = {
	WAITING_FOR_TURN = "WAITING_FOR_TURN",
	INPUT_POSITION = "INPUT_POSITION",
	INPUT_DIRECTION = "INPUT_DIRECTION",
	INPUT_POWER = "INPUT_POWER",
	READY_TO_THROW = "READY_TO_THROW",
	THROWING = "THROWING",
}
Player.STATES = STATES
function Player:init()
	Player.super.init(self)
	self:setImage(playdate.graphics.image.new("images/player"))
	self:moveTo(20, 20)
	self.state = STATES.INPUT_POSITION
end

function Player:reset()
	self.direction = playdate.geometry.vector2D.newPolar(10, 0)
	self.power = 20
	self.dir_x = 1
	self.dir_y = 1
end

function Player:next_state(new_state)
	print("Player.state from " .. self.state .. " to " .. new_state)
	self.state = new_state
end

function Player:update()
	if self.state == STATES.WAITING_FOR_TURN or self.state == STATES.THROWING then
		return
	end
	if self.state == STATES.INPUT_POSITION then
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
			self:next_state(STATES.INPUT_DIRECTION)
		end
	elseif self.state == STATES.INPUT_DIRECTION then
		if playdate.isCrankDocked() then
			playdate.ui.crankIndicator:draw()
		else
			local crank_position = playdate.getCrankPosition()
			self.direction = playdate.geometry.vector2D.newPolar(10, crank_position)
		end
		if playdate.buttonJustReleased(playdate.kButtonA) then
			self:next_state(STATES.INPUT_POWER)
			self.power_meter = PowerMeter()
			SpriteManagerSingleton:add(self.power_meter)
		end
	elseif self.state == STATES.INPUT_POWER then
		self.power = 20
		if playdate.buttonJustReleased(playdate.kButtonA) then
			self:next_state(STATES.READY_TO_THROW)
			SpriteManagerSingleton:remove(self.power_meter)
		end
	elseif self.state == STATES.READY_TO_THROW then
		self.direction:normalize()
		local dir_x, dir_y = self.direction:unpack()
		SpriteManagerSingleton:add(WhiteBall(self.x, self.y, dir_x, dir_y, self.power))
		self:reset()
		self:next_state(STATES.INPUT_POSITION)
	end
end
