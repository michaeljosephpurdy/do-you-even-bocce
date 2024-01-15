local gfx <const> = playdate.graphics
class("BocceGameScene").extends(BaseScene)

function BocceGameScene:init()
	BocceGameScene.super.init(self)
	print("BocceGameScene.init")
	local game_scene = self
end

function BocceGameScene:setup()
	self.turn_manager = BocceGameTurnManager()
	self.turn_manager:add(AiPlayer("player two", BlackBall))
	self.turn_manager:add(ControllablePlayer("player one", WhiteBall))
	local jack_ball = JackBall(math.random(150, 350), math.random(50, 150))
	self.turn_manager:add(jack_ball)
	SpriteManagerSingleton:add(jack_ball)
end

function BocceGameScene:update()
	self.turn_manager:update()
	SpriteManagerSingleton:update()
	playdate.timer.updateTimers()
	playdate.drawFPS(10, 220)
end

function BocceGameScene:destroy()
	SpriteManagerSingleton:lazy_remove_all()
end
