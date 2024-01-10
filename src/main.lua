import("CoreLibs/animator")
import("CoreLibs/easing")
import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("CoreLibs/timer")
import("CoreLibs/ui")
import("entities/base-entity")
import("entities/base-meter")
import("systems/sprite-manager")
import("scenes/bocce-game")
import("entities/ball")
import("entities/phase-overlay")
import("entities/position-meter")
import("entities/direction-meter")
import("entities/power-meter")
import("entities/spin-meter")
import("entities/player")

local gfx <const> = playdate.graphics

function init()
	SpriteManagerSingleton = SpriteManager()
	local player = Player()
	player:add()
	local jack_ball = JackBall(math.random(100, 380), math.random(50, 150))
	SpriteManagerSingleton:add(jack_ball)
end

init()

function playdate.update()
	DELTA_TIME = playdate.getElapsedTime()
	playdate.resetElapsedTime()
	if playdate.buttonJustReleased(playdate.kButtonB) then
		SpriteManagerSingleton:lazy_remove_all()
		SpriteManagerSingleton:add(JackBall(math.random(100, 400), math.random(50, 150)))
	end
	SpriteManagerSingleton:update()
	gfx.sprite.update()
	playdate.timer.updateTimers()
	playdate.drawFPS(10, 220)
end
