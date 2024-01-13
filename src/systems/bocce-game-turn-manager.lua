class("BocceGameTurnManager").extends()

function BocceGameTurnManager:init()
	self.active_player = nil
	self.inactive_player = nil
	self.players = {}
end

function BocceGameTurnManager:add(player)
	table.insert(self.players, player)
	self.inactive_player = self.players[1]
	self.active_player = player
	SpriteManagerSingleton:add(player)
end

local function determine_new_player(self)
	local next_player = self.inactive_player
	self.inactive_player = self.active_player
	self.active_player = next_player
	self.active_player:activate()
end

function BocceGameTurnManager:update()
	if self.active_player:is_done() then
		determine_new_player(self)
	end
end
