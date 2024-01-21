class("TileMapManager").extends()
TileMapManager.singleton = true

function TileMapManager:init()
	WorldLoaderSingleton:subscribe(WorldLoaderSystem.EVENTS.LOAD_LAYER, function(payload)
		local layer_sprite = Background(payload.image_path, payload.level_id)
		SpriteManagerSingleton:add(layer_sprite)
	end)
end
