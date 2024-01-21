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
	print("BocceGameScene.init")
end

function BocceGameScene:setup(payload)
	self.state = STATES.PLAYING
	self.turn_manager = BocceGameTurnManager(8)
	self.thrown_balls = {}
	self.ai_player = BocceAiPlayer(payload.ai_player.type, payload.ai_player.x, payload.ai_player.y, BlackBall)
	self.ai_player.on_throw = function(ball)
		table.insert(self.thrown_balls, ball)
	end
	self.turn_manager:add(self.ai_player)

	for k, v in pairs(payload.player) do
		print(k)
		print(v)
	end
	self.controllable_player = BocceControllablePlayer(WhiteBall, payload.player.x, payload.player.y)
	self.controllable_player.on_throw = function(ball)
		table.insert(self.thrown_balls, ball)
	end
	self.turn_manager:add(self.controllable_player)

	self.jack_ball = JackBall(math.random(150, 350), math.random(50, 150))
	self.jack_ball.x = self.jack_ball.x + self.controllable_player.x
	self.jack_ball.y = self.jack_ball.y + self.controllable_player.y
	self.turn_manager:add(self.jack_ball)
	CameraSingleton:target_centered(
		self.jack_ball.x - self.controllable_player.x,
		self.jack_ball.y - self.controllable_player.y
	)
end

function BocceGameScene:update()
	if self.state == STATES.PLAYING then
		self.turn_manager:update()
		SpriteManagerSingleton:update()
		if self.turn_manager:is_done() then
			self.score_manager = BocceGameScoreManager(self.jack_ball, self.thrown_balls)
			self.state = STATES.SCORING
		end
	elseif self.state == STATES.SCORING then
		self.score_manager:update()
		if self.score_manager:is_done() and playdate.buttonJustReleased(playdate.kButtonB) then
			self.jack_ball:remove()
			SceneManagerSingleton:next_state(OverworldScene)
		end
	end
	CameraSingleton:update()
	playdate.timer.updateTimers()
end

function BocceGameScene:destroy()
	SpriteManagerSingleton:remove_all()
end

function BocceGameScene:build_payload()
	-- TODO: return everything to set the OverworldScene back up
	return {
		player = {
			x = self.controllable_player.x,
			y = self.controllable_player.y,
		},
		ai_player = {
			x = self.ai_player.x,
			y = self.ai_player.y,
		},
	}
end
