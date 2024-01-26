import("CoreLibs/animator")
import("CoreLibs/easing")
import("CoreLibs/graphics")
import("CoreLibs/math")
import("CoreLibs/object")
-- add mixin support to CoreLibs/object
function Object:implements(...)
	for _, cls in pairs({ ... }) do
		for k, v in pairs(cls) do
			if self[k] == nil and type(v) == "function" then
				self[k] = v
			end
		end
	end
end
import("CoreLibs/sprites")
import("CoreLibs/timer")
import("CoreLibs/ui")
-- mixins
import("mixins/with-player")
import("mixins/trigger-by-player")
import("mixins/calculate-direct-throw")
import("mixins/ball-throwing")
import("mixins/pub-sub")
-- base classes
import("scenes/base-scene")
import("entities/base-entity")
import("entities/base-player")
import("entities/bocce-game/base-meter")
import("entities/bocce-game/base-player")

import("systems/camera")
import("systems/world-loader")
import("systems/sprite-manager")
import("systems/scene-manager")
import("systems/tilemap-manager")
import("scenes/bocce-game")
import("scenes/overworld")
import("entities/flat-tile")
import("entities/background")
import("entities/bocce-game/ball")
import("entities/bocce-game/phase-overlay")
import("entities/bocce-game/position-meter")
import("entities/bocce-game/direction-meter")
import("entities/bocce-game/power-meter")
import("entities/bocce-game/spin-meter")
import("entities/bocce-game/controllable-player")
import("entities/bocce-game/ai-player")
import("entities/overworld/controllable-player")
import("entities/overworld/bocce-ball-player")
import("entities/icons/speak-icon")

function init()
	WorldLoaderSingleton = WorldLoaderSystem()
	SpriteManagerSingleton = SpriteManager()
	SceneManagerSingleton = SceneManager()
	TileMapManagerSingleton = TileMapManager()
	CameraSingleton = CameraSystem()
	SceneManagerSingleton:add_state(BocceGameScene())
	SceneManagerSingleton:add_state(OverworldScene())
	--SceneManagerSingleton:next_state(BocceGameScene)
	SceneManagerSingleton:next_state(OverworldScene)
end
init()

function playdate.update()
	DELTA_TIME = playdate.getElapsedTime()
	playdate.resetElapsedTime()
	SceneManagerSingleton:update()
end
