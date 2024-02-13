local gfx <const> = playdate.graphics
local STATES = {}

class("OverworldScene").extends(BaseScene)

function OverworldScene:init()
	self.level_id = "Level_0"
	WorldLoaderSingleton:subscribe(WorldLoaderSystem.EVENTS.LOAD_ENTITY, function(payload)
		if not self.player and payload.type == "MainCharacter" then
			self.player = OverworldControllablePlayer(payload)
			SpriteManagerSingleton:add(self.player)
		elseif payload.type == "BocceBallPlayer" then
			local other_player = OverworldBocceBallPlayer(payload)
			other_player.target = self.player
			other_player.singleton = true
			SpriteManagerSingleton:add(other_player)
		elseif payload.type == "Door" then
			local door = Door(payload)
			SpriteManagerSingleton:add(door)
		elseif payload.type == "Sign" then
			local sign = Sign(payload)
			SpriteManagerSingleton:add(sign)
		end
	end)
end

function OverworldScene:setup(payload)
	if self.player then
		SpriteManagerSingleton:enable(self.player)
	end
	if self.level_id == payload.level_id then
		return
	end
	if payload and payload.level_id then
		self.level_id = payload.level_id
	end
	self.level_id = WorldLoaderSingleton:load(self.level_id)
	if payload.source and payload.source:isa(BocceGameScene) then
		self.player.lock_controls = true
		if payload.player_won then
			self.player.interacting_with:player_won(self.player)
		else
			self.player.interacting_with:player_lost(self.player)
		end
	end
end

function OverworldScene:update()
	SpriteManagerSingleton:update()
	CameraSingleton:update()
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
			x = self.player.interacting_with.x,
			y = self.player.interacting_with.y,
			type = self.player.interacting_with.type,
		},
	}
end

function OverworldScene:destroy()
	-- TODO: destroy all overworld-only sprites
	SpriteManagerSingleton:disable(self.player)
end
