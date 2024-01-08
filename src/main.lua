import("CoreLibs/animator")
import("CoreLibs/easing")
import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("CoreLibs/timer")
import("CoreLibs/ui")
import("entities/base-entity")
import("systems/sprite-manager")
import("scenes/bocce-game")
import("entities/base-entity")
import("entities/ball")
import("entities/direction-meter")
import("entities/phase-overlay")
import("entities/player")
import("entities/power-meter")

local gfx <const> = playdate.graphics

function init()
	SpriteManagerSingleton = SpriteManager()
	local player = Player()
	player:add()
end

init()

function playdate.update()
	DELTA_TIME = playdate.getElapsedTime()
	playdate.resetElapsedTime()
	if playdate.buttonJustReleased(playdate.kButtonB) then
		SpriteManagerSingleton:lazy_remove_all()
	end
	SpriteManagerSingleton:update()
	gfx.sprite.update()
	playdate.timer.updateTimers()
end
