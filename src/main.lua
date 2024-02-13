import("CoreLibs/animator")
import("CoreLibs/easing")
import("CoreLibs/graphics")
import("CoreLibs/math")
import("CoreLibs/nineslice")
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
import("mixins/bouncing-icon")
-- base classes
import("scenes/base-scene")
import("entities/base-entity")
import("entities/base-player")
import("entities/base-tile")
import("entities/bocce-game/base-meter")
import("entities/bocce-game/base-player")

import("systems/camera")
import("systems/world-loader")
import("systems/sprite-manager")
import("systems/scene-manager")
import("systems/tilemap-manager")
import("systems/screen-transition")
import("systems/dialogue")
import("scenes/bocce-game")
import("scenes/overworld")
import("entities/collider-tile")
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
import("entities/icon")
import("entities/door")
import("entities/sign")

Z_INDEXES = {
	TRANSITION = 32766,
	DIALOGUE = 32763,
	UI = 32760,
	ICONS = 32750,
	METERS = 32740,
}
COLLIDER_TAGS = {
	PLAYER = 1,
	OBSTACLE = 2,
	TRIGGER = 3,
	BALL = 4,
}
function init()
	WorldLoaderSingleton = WorldLoaderSystem()
	SpriteManagerSingleton = SpriteManager()
	SceneManagerSingleton = SceneManager()
	TileMapManagerSingleton = TileMapManager()
	CameraSingleton = CameraSystem()
	ScreenTransitionSingleton = ScreenTransitionSystem()
	DialogueSystemSingleton = DialogueSystem()
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
