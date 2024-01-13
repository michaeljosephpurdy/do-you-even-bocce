local gfx <const> = playdate.graphics
class("BocceGameScene").extends(BaseScene)

function BocceGameScene:init()
	print("BocceGameScene.init")
end

function BocceGameScene:setup()
	self.turn_manager = BocceGameTurnManager()
	self.turn_manager:add(ControllablePlayer("player one", WhiteBall))
	self.turn_manager:add(AiPlayer("player two", BlackBall))
	local jack_ball = JackBall(math.random(100, 380), math.random(50, 150))
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
