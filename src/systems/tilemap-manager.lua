class("TileMapManager").extends()
TileMapManager.singleton = true

function TileMapManager:init()
	WorldLoaderSingleton:subscribe(WorldLoaderSystem.EVENTS.LOAD_LAYER, function(payload)
		local layer_sprite = Background(payload)
		SpriteManagerSingleton:add(layer_sprite)
	end)
	WorldLoaderSingleton:subscribe(WorldLoaderSystem.EVENTS.LOAD_TILE, function(payload)
		if payload.collider then
			local tile = ColliderTile(payload)
			SpriteManagerSingleton:add(tile)
		else
			local tile = BaseTile(payload)
			--SpriteManagerSingleton:add(tile)
		end
	end)
end
