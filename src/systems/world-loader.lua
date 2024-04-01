local file <const> = playdate.file
local PATH = "data/tilemap/"

class("WorldLoaderSystem").extends()
WorldLoaderSystem:implements(PubSubMixin)
WorldLoaderSystem.singleton = true

WorldLoaderSystem.EVENTS = {
	LOAD_LEVEL = "LOAD_LEVEL",
	LOAD_LAYER = "LOAD_LAYER",
	LOAD_ENTITY = "LOAD_ENTITY",
	LOAD_TILE = "LOAD_TILE",
}

local function decode_json(file_path)
	local data, error = json.decodeFile(file_path)
	if error then
		print("error decoding " .. tostring(file_path))
		print(error)
	end
	return data
end

local function parse_level(level_data)
	local neighbor_uids = {}
	for _, neighbor in pairs(level_data.__neighbours) do
		table.insert(neighbor_uids, neighbor.levelIid)
	end
	return {
		uid = level_data.iid,
		id = level_data.identifier,
		x = level_data.worldX,
		y = level_data.worldY,
		width = level_data.pxWid,
		height = level_data.pxHei,
		xx = level_data.worldX + level_data.pxWid,
		yy = level_data.worldY + level_data.pxHei,
		tiles = {},
		entities = {},
		layers = {},
		neighbor_uids = neighbor_uids,
	}
end

local function parse_tile(level, layer, tile)
	local collider = false
	local z_index = -layer.z_index
	if layer.__identifier == "Upper" then
		z_index = z_index + 100
	end
	if layer.__identifier:sub(-9) == "_Collider" then
		collider = true
	end
	return {
		level_id = level.uid,
		x = level.x + tile.px[1],
		y = level.y + tile.px[2],
		z_index_offset = z_index,
		image_number = tile.t + 1,
		img_x = tile.src[1],
		img_y = tile.src[2],
		collider = collider,
	}
end

local function parse_layer(level, layer, index)
	local png = string.format("%s/world/png/%s.png", PATH, level.id)
	local z_index = level.y
	if layer then
		-- layer png path is like this: data/tilemap/world/png/Level_0__Grass.png
		png = string.format("%s/world/png/%s__%s.png", PATH, level.id, layer.__identifier)
		z_index = layer.z_index
		if layer.__identifier == "Upper" then
			z_index = z_index + level.yy
		end
	end
	return {
		bg = layer == nil,
		x = level.x,
		y = level.y,
		z_index = z_index,
		image_source = png,
		level_id = level.id,
		level_uid = level.uid,
	}
end

local function parse_entity(level, layer, entity_data)
	local entity = {
		level_id = level.uid,
		type = entity_data.__identifier,
		uid = entity_data.iid,
		x = level.x + entity_data.px[1],
		y = level.y + entity_data.px[2],
	}
	for _, field in ipairs(entity_data.fieldInstances) do
		entity[field.__identifier] = field.__value
	end
	return entity
end

local function parse_world(self, file_path)
	-- structure
	-- world
	-- |- level
	--    |- layers
	--       |- gridTiles
	--       |- entityInstances
	local world_file, error = file.open(file_path, file.kFileRead)
	if error then
		print("error reading " .. tostring(file_path))
		print(error)
	end
	self.world = {
		levels = {},
	}
	-- first, parse the json
	local world_data = decode_json(world_file)
	-- then, loop through all 'levels' and store
	-- levels, layers, tiles, entities, etc in ram
	-- *this is not the same as instantiating these objects*
	for _, level_data in pairs(world_data.levels) do
		local level = parse_level(level_data)
		self.levels[level.uid] = level
		self.world.levels[level.id] = level
		local top_layer = #level_data.layerInstances
		table.insert(level.layers, parse_layer(level))
		for i, layer in ipairs(level_data.layerInstances) do
			layer.z_index = top_layer - i
			if layer.__identifier == "Upper" and (layer.__type == "Tiles" or layer.__type == "AutoLayer") then
				table.insert(level.layers, parse_layer(level, layer))
			end
			if layer.autoLayerTiles then
				for _, tile in pairs(layer.autoLayerTiles) do
					table.insert(level.tiles, parse_tile(level, layer, tile))
				end
			end
			if layer.gridTiles then
				for _, tile in pairs(layer.gridTiles) do
					table.insert(level.tiles, parse_tile(level, layer, tile))
				end
			end
			for _, raw_entity in ipairs(layer.entityInstances) do
				local entity = parse_entity(level, layer, raw_entity)
				self.entities[entity.uid] = entity
				table.insert(level.entities, entity)
			end
		end
	end
	-- after all levels have been parsed,
	-- we need to loop through one more time to tie all of the
	-- neighboring levels with eachother
	for _, level in pairs(self.levels) do
		if #level.neighbor_uids > 0 then
			level.neighbors = {}
		end
		for _, neighbor_uid in pairs(level.neighbor_uids) do
			table.insert(level.neighbors, self.levels[neighbor_uid])
		end
	end
	MemoryPrinter:log("world loaded")
end

function WorldLoaderSystem:init()
	self.world = {}
	self.entities = {}
	self.levels = {}
	self:register_events(WorldLoaderSystem.EVENTS)
end

function WorldLoaderSystem:load(level_id)
	MemoryPrinter:log("WorldLoader.before_parse")
	parse_world(self, PATH .. "world.ldtk")
	MemoryPrinter:log("WorldLoader.after_parse")
	if self.loaded_level_id == level_id then
		return self.loaded_level_id
	end
	print("loading " .. level_id)
	local level = self.world.levels[level_id]
	if not level then
		level = self.levels[level_id]
	end
	self.loaded_level_id = level.uid
	self:publish(WorldLoaderSystem.EVENTS.LOAD_LEVEL, level)
	if level.neighbors then
		for _, neighbor in ipairs(level.neighbors) do
			for _, layer in ipairs(neighbor.layers) do
				self:publish(WorldLoaderSystem.EVENTS.LOAD_LAYER, layer)
			end
		end
	end
	for _, layer in ipairs(level.layers) do
		self:publish(WorldLoaderSystem.EVENTS.LOAD_LAYER, layer)
	end
	for _, tile in ipairs(level.tiles) do
		self:publish(WorldLoaderSystem.EVENTS.LOAD_TILE, tile)
	end
	for _, entity in ipairs(level.entities) do
		self:publish(WorldLoaderSystem.EVENTS.LOAD_ENTITY, entity)
	end
	MemoryPrinter:log("WorldLoader.after_load")
	self.world = {}
	self.entities = {}
	self.levels = {}
	MemoryPrinter:log("WorldLoader.after_purge")
	return self.loaded_level_id
end

function WorldLoaderSystem:get_entity(id)
	return self.entities[id]
end
