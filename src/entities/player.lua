local gfx <const> = playdate.graphics
class("Player").extends(gfx.sprite)

local STATES = {
	WAITING_FOR_TURN = "WAITING_FOR_TURN",
	INPUT_POSITION = "INPUT_POSITION",
	INPUT_DIRECTION = "INPUT_DIRECTION",
	INPUT_SPIN = "INPUT_SPIN",
	INPUT_POWER = "INPUT_POWER",
	READY_TO_THROW = "READY_TO_THROW",
	THROWING = "THROWING",
}
Player.STATES = STATES
function Player:init()
	Player.super.init(self)
	self:setImage(gfx.image.new("images/player-small"))
	self:moveTo(40, 100)
	self.state = STATES.INPUT_POSITION
	self.overlay = PositionPhaseOverlay()
	self.position_meter = PositionMeter(self.x, self.y, self)
	SpriteManagerSingleton:add(self.position_meter)
end

function Player:reset()
	self.direction = playdate.geometry.vector2D.newPolar(10, 0)
	self.power = 200
	self.dir_x = 1
	self.dir_y = 1
	self.spin = 0
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
		if self.position_meter:player_out_of_bounds(self) then
			print("out of bounds")
		else
			print("in bounds")
		end
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
			SpriteManagerSingleton:remove(self.position_meter)
			SpriteManagerSingleton:remove(self.overlay)
			self.overlay = DirectionPhaseOverlay()
			SpriteManagerSingleton:add(self.overlay)
			self.direction_meter = DirectionMeter(self.x, self.y, self.direction_degree)
			SpriteManagerSingleton:add(self.direction_meter)
			self:next_state(STATES.INPUT_DIRECTION)
		end
	elseif self.state == STATES.INPUT_DIRECTION then
		if playdate.buttonJustReleased(playdate.kButtonA) then
			self.direction, self.direction_degree = self.direction_meter:get_value()
			SpriteManagerSingleton:remove(self.direction_meter)
			SpriteManagerSingleton:remove(self.overlay)
			self.overlay = SpinPhaseOverlay()
			SpriteManagerSingleton:add(self.overlay)
			self:next_state(STATES.INPUT_SPIN)
			self.spin_meter = SpinMeter(self.x, self.y, self.direction_degree)
			SpriteManagerSingleton:add(self.spin_meter)
		end
	elseif self.state == STATES.INPUT_SPIN then
		if playdate.buttonJustReleased(playdate.kButtonA) then
			self.spin = self.spin_meter:get_value()
			SpriteManagerSingleton:remove(self.overlay)
			SpriteManagerSingleton:remove(self.spin_meter)
			self.overlay = PowerPhaseOverlay()
			SpriteManagerSingleton:add(self.overlay)
			self:next_state(STATES.INPUT_POWER)
			self.power_meter = PowerMeter(self.x, self.y, self.direction_degree)
			SpriteManagerSingleton:add(self.power_meter)
		end
	elseif self.state == STATES.INPUT_POWER then
		if playdate.buttonJustReleased(playdate.kButtonA) then
			self.power = self.power_meter:get_value()
			self:next_state(STATES.READY_TO_THROW)
			SpriteManagerSingleton:remove(self.power_meter)
			SpriteManagerSingleton:remove(self.overlay)
		end
	elseif self.state == STATES.READY_TO_THROW then
		self.direction:normalize()
		local dir_x, dir_y = self.direction:unpack()
		SpriteManagerSingleton:add(WhiteBall(self.x, self.y, dir_x, dir_y, self.power))
		self:reset()
		self:next_state(STATES.INPUT_POSITION)
		self.position_meter = PositionMeter(self.x, self.y, self)
		SpriteManagerSingleton:add(self.position_meter)
		self.overlay = PositionPhaseOverlay()
		SpriteManagerSingleton:add(self.overlay)
	end
end
