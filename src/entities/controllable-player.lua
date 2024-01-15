local gfx <const> = playdate.graphics
class("ControllablePlayer").extends(BasePlayer)

local STATES = {
	WAITING_FOR_TURN = "WAITING_FOR_TURN",
	INPUT_POSITION = "INPUT_POSITION",
	INPUT_DIRECTION = "INPUT_DIRECTION",
	INPUT_SPIN = "INPUT_SPIN",
	INPUT_POWER = "INPUT_POWER",
	READY_TO_THROW = "READY_TO_THROW",
	THROWING = "THROWING",
}
ControllablePlayer.STATES = STATES

function ControllablePlayer:init(name, ball_type)
	ControllablePlayer.super.init(self, name, ball_type)
	self:setImage(gfx.image.new("images/player-small"))
	if ball_type:isa(BlackBall) then
		self:setImage(gfx.image.new("images/other-player-small"))
	end
	self:moveTo(40, 100)
	self.state = STATES.WAITING_FOR_TURN
	self.overlay = PositionPhaseOverlay()
	self.input_meter = PositionMeter(self.x, self.y, self)
	self:fix_z_index()
end

function ControllablePlayer:activate()
	ControllablePlayer.super.activate(self)
	self.input_meter = PositionMeter(self.x, self.y, self)
	SpriteManagerSingleton:add(self.input_meter)
	self.overlay = PositionPhaseOverlay()
	SpriteManagerSingleton:add(self.overlay)
	self:next_state(ControllablePlayer.STATES.INPUT_POSITION)
end

function ControllablePlayer:reset()
	self.direction = playdate.geometry.vector2D.newPolar(10, 0)
	self.power = 200
	self.dir_x = 1
	self.dir_y = 1
	self.spin = 0
end

function ControllablePlayer:next_state(new_state)
	print("ControllablePlayer.state from " .. self.state .. " to " .. new_state)
	self.state = new_state
end

function ControllablePlayer:update()
	if self.state == STATES.WAITING_FOR_TURN then
		return
	end
	ControllablePlayer.super.update(self)
	if self.state == STATES.INPUT_POSITION then
		if playdate.buttonIsPressed(playdate.kButtonLeft) then
			local new_x = self.x - 1
			if self.input_meter:is_in_bounds(new_x, self.y) then
				self:moveTo(new_x, self.y)
			end
		elseif playdate.buttonIsPressed(playdate.kButtonRight) then
			local new_x = self.x + 1
			if self.input_meter:is_in_bounds(new_x, self.y) then
				self:moveTo(new_x, self.y)
			end
		end
		if playdate.buttonIsPressed(playdate.kButtonUp) then
			local new_y = self.y - 1
			if self.input_meter:is_in_bounds(self.x, new_y) then
				self:moveTo(self.x, new_y)
			end
		elseif playdate.buttonIsPressed(playdate.kButtonDown) then
			local new_y = self.y + 1
			if self.input_meter:is_in_bounds(self.x, new_y) then
				self:moveTo(self.x, new_y)
			end
		end
		if playdate.buttonJustReleased(playdate.kButtonA) then
			SpriteManagerSingleton:remove(self.input_meter)
			SpriteManagerSingleton:remove(self.overlay)
			self.overlay = DirectionPhaseOverlay()
			SpriteManagerSingleton:add(self.overlay)
			self.input_meter = DirectionMeter(self.x, self.y, self.direction_degree)
			SpriteManagerSingleton:add(self.input_meter)
			self:next_state(STATES.INPUT_DIRECTION)
		end
	elseif self.state == STATES.INPUT_DIRECTION then
		if playdate.buttonJustReleased(playdate.kButtonA) then
			self.direction, self.direction_degree = self.input_meter:get_value()
			SpriteManagerSingleton:remove(self.input_meter)
			SpriteManagerSingleton:remove(self.overlay)
			self.overlay = SpinPhaseOverlay()
			SpriteManagerSingleton:add(self.overlay)
			self:next_state(STATES.INPUT_SPIN)
			self.input_meter = SpinMeter(self.x, self.y, self.direction_degree)
			SpriteManagerSingleton:add(self.input_meter)
		end
	elseif self.state == STATES.INPUT_SPIN then
		if playdate.buttonJustReleased(playdate.kButtonA) then
			self.spin = self.input_meter:get_value()
			SpriteManagerSingleton:remove(self.overlay)
			SpriteManagerSingleton:remove(self.input_meter)
			self.overlay = PowerPhaseOverlay()
			SpriteManagerSingleton:add(self.overlay)
			self:next_state(STATES.INPUT_POWER)
			self.input_meter = PowerMeter(self.x, self.y, self.direction_degree)
			SpriteManagerSingleton:add(self.input_meter)
		end
	elseif self.state == STATES.INPUT_POWER then
		if playdate.buttonJustReleased(playdate.kButtonA) then
			self.power = self.input_meter:get_value()
			self:next_state(STATES.READY_TO_THROW)
			SpriteManagerSingleton:remove(self.input_meter)
			SpriteManagerSingleton:remove(self.overlay)
		end
	elseif self.state == STATES.READY_TO_THROW then
		self.direction:normalize()
		local dir_x, dir_y = self.direction:unpack()
		self.thrown_ball = self.ball_type(self.x, self.y, dir_x, dir_y, self.power, self.spin)
		self.thrown_ball.player = self
		SpriteManagerSingleton:add(self.thrown_ball)
		self:reset()
		self:next_state(STATES.THROWING)
	elseif self.state == STATES.THROWING then
		if self.thrown_ball:is_done() then
			self:next_state(STATES.WAITING_FOR_TURN)
		end
	end
end

function ControllablePlayer:is_done()
	return self.state == STATES.WAITING_FOR_TURN
end
