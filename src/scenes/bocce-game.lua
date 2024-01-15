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

function BocceGameScene:setup()
	self.state = STATES.PLAYING
	self.turn_manager = BocceGameTurnManager(2)
	self.thrown_balls = {}
	local ai_player = AiPlayer("player two", BlackBall)
	ai_player.on_throw = function(ball)
		table.insert(self.thrown_balls, ball)
	end
	self.turn_manager:add(ai_player)

	local controllable_player = ControllablePlayer("player one", WhiteBall)
	controllable_player.on_throw = function(ball)
		table.insert(self.thrown_balls, ball)
	end
	self.turn_manager:add(controllable_player)

	local jack_ball = JackBall(math.random(150, 350), math.random(50, 150))
	self.turn_manager:add(jack_ball)
	SpriteManagerSingleton:add(jack_ball)
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
		if self.score_manager:is_done() then
		end
	end
	playdate.timer.updateTimers()
	playdate.drawFPS(10, 220)
end

function BocceGameScene:destroy()
	SpriteManagerSingleton:lazy_remove_all()
end
