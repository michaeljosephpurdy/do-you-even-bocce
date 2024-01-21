local gfx <const> = playdate.graphics
local STATES = {}

class("OverworldScene").extends(BaseScene)

function OverworldScene:init()
	self.level_id = "Level_0"
	WorldLoaderSingleton:subscribe(WorldLoaderSystem.EVENTS.LOAD_ENTITY, function(payload)
		if not self.player and payload.id == "MainCharacter" then
			self.player = OverworldControllablePlayer(payload.x, payload.y)
			SpriteManagerSingleton:add(self.player)
		elseif payload.id == "BocceBallPlayer" then
			local other_player = OverworldBocceBallPlayer(payload.BoccePlayers, payload.x, payload.y)
			other_player.target = self.player
			other_player.singleton = true
			SpriteManagerSingleton:add(other_player, payload.x, payload.y)
		end
	end)
end

function OverworldScene:setup(payload)
	if self.player then
		SpriteManagerSingleton:enable(self.player)
	end
	if payload and payload.level_id then
		self.level_id = payload.level_id
	end
	WorldLoaderSingleton:load(self.level_id)
end

function OverworldScene:update()
	SpriteManagerSingleton:update()
	playdate.timer.updateTimers()
end

function OverworldScene:build_payload()
	-- TODO: return player location, ai player data, etc.
	return {
		player = {
			x = self.player.x,
			y = self.player.y,
		},
		ai_player = {
			x = self.player.target.x,
			y = self.player.target.y,
			type = self.player.target.type,
		},
	}
end

function OverworldScene:destroy()
	-- TODO: destroy all overworld-only sprites
	SpriteManagerSingleton:disable(self.player)
end
