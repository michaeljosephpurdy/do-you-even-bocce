import("systems/bocce-game-turn-manager")
import("systems/bocce-game-score-manager")

local gfx <const> = playdate.graphics
class("BocceGameScene").extends(BaseScene)
local STATES = {
	PLAYING = "PLAYING",
	SCORING = "SCORING",
	EXITING = "EXITING",
}
BocceGameScene.STATES = STATES

function BocceGameScene:init()
	BocceGameScene.super.init(self)
	self.level_id = "bocce_game"
end

function BocceGameScene:setup(payload)
	self.state = STATES.PLAYING
	self.turn_manager = BocceGameTurnManager(8, self.level_id)
	self.thrown_balls = {}
	self.ai_player =
		BocceAiPlayer(payload.ai_player.type, payload.ai_player.x, payload.ai_player.y, BlackBall, self.level_id)
	self.ai_player.on_throw = function(ball)
		table.insert(self.thrown_balls, ball)
	end
	self.turn_manager:add(self.ai_player)

	self.controllable_player = BocceControllablePlayer(WhiteBall, payload.player.x, payload.player.y, self.level_id)
	self.controllable_player.on_throw = function(ball)
		table.insert(self.thrown_balls, ball)
	end
	self.turn_manager:add(self.controllable_player)

	self.jack_ball = JackBall(payload.player.x + math.random(150, 350), payload.player.y + math.random(50, 150))
	self.turn_manager:add(self.jack_ball)
	CameraSingleton:target_sprite_centered(self.jack_ball)
end

function BocceGameScene:update()
	if self.state == STATES.PLAYING then
		if playdate.buttonIsPressed(playdate.kButtonB) then
			CameraSingleton:target_sprite_centered(self.jack_ball)
		elseif self.turn_manager.active_player.thrown_ball then
			CameraSingleton:target_between_sprites_centered(
				self.turn_manager.active_player.thrown_ball,
				self.jack_ball,
				1.5
			)
		else
			CameraSingleton:target_between_sprites_centered(self.turn_manager.active_player, self.jack_ball)
		end
		self.turn_manager:update()
		SpriteManagerSingleton:update()
		if self.turn_manager:is_done() then
			self.score_manager = BocceGameScoreManager(self.jack_ball, self.thrown_balls)
			self.state = STATES.SCORING
		end
	elseif self.state == STATES.SCORING then
		self.score_manager:update()
		if self.score_manager:is_done() then
			self.state = STATES.EXITING
			self.jack_ball:remove()
		end
	elseif self.state == STATES.EXITING then
		CameraSingleton:target_between_sprites_centered(self.ai_player, self.controllable_player)
		SceneManagerSingleton:next_state(OverworldScene)
	end
	CameraSingleton:update()
	playdate.timer.updateTimers()
end

function BocceGameScene:destroy()
	SpriteManagerSingleton:purge_level(self.level_id)
end

function BocceGameScene:build_payload()
	return {
		player = {
			x = self.controllable_player.x,
			y = self.controllable_player.y,
		},
		ai_player = {
			x = self.ai_player.x,
			y = self.ai_player.y,
		},
		player_won = self.score_manager:player_won(),
	}
end
