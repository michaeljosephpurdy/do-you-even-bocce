class("BocceGameTurnManager").extends()

function BocceGameTurnManager:init(balls_per_player)
	self.active_player = nil
	self.inactive_player = nil
	self.players = {}
	self.balls = balls_per_player
end

function BocceGameTurnManager:add(entity)
	if entity:isa(BasePlayer) then
		table.insert(self.players, entity)
		self.inactive_player = self.players[1]
		self.active_player = entity
		SpriteManagerSingleton:add(entity)
	elseif entity:isa(JackBall) then
		for _, player in pairs(self.players) do
			player.jack_ball = entity
		end
	end
end

local function determine_new_player(self)
	local next_player = self.inactive_player
	self.inactive_player = self.active_player
	self.inactive_player:deactivate()
	self.active_player = next_player
	self.active_player:activate()
	print("self.inactive_player " .. self.inactive_player.name)
	print("self.active_player " .. self.active_player.name)
	self.balls = self.balls - 1
	print(self.balls)
end

function BocceGameTurnManager:update()
	if self.game_over then
		return
	end
	if self.balls == 0 then
		self.game_over = true
	end
	if self.active_player:is_done() then
		determine_new_player(self)
	end
end

function BocceGameTurnManager:is_done()
	return self.game_over and self.active_player:is_done()
end
