import("CoreLibs/animator")
import("CoreLibs/easing")
import("CoreLibs/graphics")
import("CoreLibs/math")
import("CoreLibs/nineslice")
import("CoreLibs/object")
import("CoreLibs/utilities/sampler")
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
-- plugins
import("plugins/memory-printer")
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
import("entities/overworld/background-detector")
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
	NO_OP = 0,
	PLAYER = 1,
	OBSTACLE = 2,
	TRIGGER = 3,
	BALL = 4,
}
COLLIDER_GROUPS = {
	PLAYER = 1,
	SOLID = 2,
}
GAME_SIZE = {
	WIDTH = 400,
	HEIGHT = 240,
}
function init()
	WorldLoaderSingleton = WorldLoaderSystem()
	SpriteManagerSingleton = SpriteManager({ tile_size = 32 })
	SceneManagerSingleton = SceneManager()
	TileMapManagerSingleton = TileMapManager()
	CameraSingleton = CameraSystem()
	ScreenTransitionSingleton = ScreenTransitionSystem()
	DialogueSystemSingleton = DialogueSystem()
	SceneManagerSingleton:add_scene(BocceGameScene())
	SceneManagerSingleton:add_scene(OverworldScene())
	--SceneManagerSingleton:next_scene(BocceGameScene)
	SceneManagerSingleton:next_scene(OverworldScene)
end
init()

function playdate.update()
	DELTA_TIME = playdate.getElapsedTime()
	playdate.resetElapsedTime()
	SceneManagerSingleton:update()
	playdate.drawFPS(5, 225)
end
