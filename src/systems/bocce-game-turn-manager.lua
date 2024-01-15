class("BocceGameTurnManager").extends()

function BocceGameTurnManager:init()
	self.active_player = nil
	self.inactive_player = nil
	self.players = {}
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
end

function BocceGameTurnManager:update()
	if self.active_player:is_done() then
		determine_new_player(self)
	end
end
