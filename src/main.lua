import("CoreLibs/animator")
import("CoreLibs/easing")
import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("CoreLibs/timer")
import("CoreLibs/ui")
-- base classes
import("scenes/base-scene")
import("entities/base-entity")
import("entities/base-player")
import("entities/base-meter")

import("systems/sprite-manager")
import("systems/scene-manager")
import("scenes/bocce-game")
import("entities/ball")
import("entities/phase-overlay")
import("entities/position-meter")
import("entities/direction-meter")
import("entities/power-meter")
import("entities/spin-meter")
import("entities/controllable-player")
import("entities/ai-player")

function init()
	SpriteManagerSingleton = SpriteManager()
	SceneManagerSingleton = SceneManager()
	SceneManagerSingleton:add_state(BocceGameScene())
	SceneManagerSingleton:next_state(BocceGameScene)
end

init()

function playdate.update()
	if playdate.buttonJustReleased(playdate.kButtonB) then
		SceneManagerSingleton:next_state(BocceGameScene)
	end
	DELTA_TIME = playdate.getElapsedTime()
	playdate.resetElapsedTime()
	SceneManagerSingleton:update()
end
