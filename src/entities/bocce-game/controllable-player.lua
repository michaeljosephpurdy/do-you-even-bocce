local gfx <const> = playdate.graphics
class("BocceControllablePlayer").extends(BaseBoccePlayer)
BocceControllablePlayer.is_player = true
BocceControllablePlayer:implements(BallThrowingMixin)

local STATES = {
	WAITING_FOR_TURN = "WAITING_FOR_TURN",
	INPUT_POSITION = "INPUT_POSITION",
	INPUT_DIRECTION = "INPUT_DIRECTION",
	INPUT_SPIN = "INPUT_SPIN",
	INPUT_POWER = "INPUT_POWER",
	READY_TO_THROW = "READY_TO_THROW",
	THROWING = "THROWING",
}
BocceControllablePlayer.STATES = STATES

function BocceControllablePlayer:init(ball_type, x, y)
	BocceControllablePlayer.super.init(self, BasePlayer.TYPES.MAIN, ball_type)
	self.in_game = true
	self:moveTo(x, y)
	self.state = STATES.WAITING_FOR_TURN
	self.overlay = PositionPhaseOverlay()
	self.input_meter = PositionMeter(self.x, self.y, self)
	self:fix_draw_order()
end

function BocceControllablePlayer:activate()
	BocceControllablePlayer.super.activate(self)
	self.input_meter = PositionMeter(self.x, self.y, self, self.level_id)
	SpriteManagerSingleton:add(self.input_meter)
	self.overlay = PositionPhaseOverlay(self.level_id)
	SpriteManagerSingleton:add(self.overlay)
	self:next_state(BocceControllablePlayer.STATES.INPUT_POSITION)
end

function BocceControllablePlayer:reset()
	self.direction = playdate.geometry.vector2D.newPolar(10, 0)
	self.power = 200
	self.dir_x = 1
	self.dir_y = 1
	self.spin = 0
end

function BocceControllablePlayer:next_state(new_state)
	print("BocceControllablePlayer.state from " .. self.state .. " to " .. new_state)
	self.state = new_state
end

function BocceControllablePlayer:update()
	if self.state == STATES.WAITING_FOR_TURN then
		return
	end
	BocceControllablePlayer.super.update(self)
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
			self.overlay = DirectionPhaseOverlay(self.level_id)
			SpriteManagerSingleton:add(self.overlay)
			self.input_meter = DirectionMeter(self.x, self.y, self.direction_degree, self.level_id)
			SpriteManagerSingleton:add(self.input_meter)
			self:next_state(STATES.INPUT_DIRECTION)
		end
	elseif self.state == STATES.INPUT_DIRECTION then
		if playdate.buttonJustReleased(playdate.kButtonA) then
			self.direction, self.direction_degree = self.input_meter:get_value()
			SpriteManagerSingleton:remove(self.input_meter)
			SpriteManagerSingleton:remove(self.overlay)
			self.overlay = SpinPhaseOverlay(self.level_id)
			SpriteManagerSingleton:add(self.overlay)
			self:next_state(STATES.INPUT_SPIN)
			self.input_meter = SpinMeter(self.x, self.y, self.direction_degree, self.level_id)
			SpriteManagerSingleton:add(self.input_meter)
		end
	elseif self.state == STATES.INPUT_SPIN then
		if playdate.buttonJustReleased(playdate.kButtonA) then
			self.spin = self.input_meter:get_value()
			SpriteManagerSingleton:remove(self.overlay)
			SpriteManagerSingleton:remove(self.input_meter)
			self.overlay = PowerPhaseOverlay(self.level_id)
			SpriteManagerSingleton:add(self.overlay)
			self:next_state(STATES.INPUT_POWER)
			self.input_meter = PowerMeter(self.x, self.y, self.direction_degree, self.level_id)
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
		local jump_height = 10
		self.thrown_ball = self:throw_ball(self.x, self.y, dir_x, dir_y, self.power, self.spin, jump_height)
		self:reset()
		self:next_state(STATES.THROWING)
	elseif self.state == STATES.THROWING then
		if self.thrown_ball:is_done() then
			self:next_state(STATES.WAITING_FOR_TURN)
			self.thrown_ball = nil
		end
	end
end

function BocceControllablePlayer:is_done()
	return self.state == STATES.WAITING_FOR_TURN
end
