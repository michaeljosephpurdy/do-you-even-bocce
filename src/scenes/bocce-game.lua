local gfx <const> = playdate.graphics
class("BocceGameScene").extends(BaseScene)

function BocceGameScene:init() end

function BocceGameScene:setup()
	local player = Player()
	local jack_ball = JackBall(math.random(100, 380), math.random(50, 150))
	SpriteManagerSingleton:add(player)
	SpriteManagerSingleton:add(jack_ball)
end

function BocceGameScene:update()
	SpriteManagerSingleton:update()
	playdate.timer.updateTimers()
	playdate.drawFPS(10, 220)
end

function BocceGameScene:destroy()
	SpriteManagerSingleton:lazy_remove_all()
end
