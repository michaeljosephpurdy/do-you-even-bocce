import("CoreLibs/object")
import("CoreLibs/graphics")
import("CoreLibs/sprites")
import("CoreLibs/timer")
import("systems/sprite-manager")
import("scenes/bocce-game")
import("entities/base-entity")
import("entities/ball")
import("entities/player")

local gfx <const> = playdate.graphics

function init()
	SpriteManagerSingleton = SpriteManager()
	local player = Player()
	player:add()
end

init()

function playdate.update()
	if playdate.buttonJustReleased(playdate.kButtonB) then
		SpriteManagerSingleton:lazy_remove_all()
	end
	SpriteManagerSingleton:update()
	playdate.resetElapsedTime()
	gfx.sprite.update()
	playdate.timer.updateTimers()
end
