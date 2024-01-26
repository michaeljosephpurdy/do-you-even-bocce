class("TileMapManager").extends()
TileMapManager.singleton = true

function TileMapManager:init()
	WorldLoaderSingleton:subscribe(WorldLoaderSystem.EVENTS.LOAD_LAYER, function(payload)
		local layer_sprite = Background(payload.image_path, payload.level_id)
		SpriteManagerSingleton:add(layer_sprite)
	end)
	WorldLoaderSingleton:subscribe(WorldLoaderSystem.EVENTS.LOAD_TILE, function(payload)
		local tile = FlatTile(payload.x, payload.y, payload.z_index_offset, payload.image_number, payload.collider)
		SpriteManagerSingleton:add(tile)
	end)
end
