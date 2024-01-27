local file <const> = playdate.file
local PATH = "data/tilemap/"
local BASE_PATH = PATH .. "world/simplified/"

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

local function decode_level(level_id)
	local level_path = BASE_PATH .. level_id .. "/"
	local data_file = level_path .. "data.json"
	local level_file, error = file.open(data_file, file.kFileRead)
	if error then
		print("error reading " .. tostring(data_file))
		print(error)
	end
	local data = decode_json(level_file)
	assert(data)
	local level = {
		id = level_id,
		x = data.x,
		y = data.y,
		width = data.width,
		height = data.height,
		uid = data.uniqueIdentifier,
		layers = {},
		entities = {},
	}
	for _, layer_file in ipairs(data.layers) do
		table.insert(level.layers, level_path .. layer_file)
	end
	for _, entities in pairs(data.entities) do
		for _, entity in ipairs(entities) do
			for k, v in pairs(entity.customFields) do
				entity[k] = v
			end
			entity.customFields = nil
			table.insert(level.entities, entity)
		end
	end
	return level
end

local function decode_world(self, file_path)
	local world_file, error = file.open(file_path, file.kFileRead)
	if error then
		print("error reading " .. tostring(file_path))
		print(error)
	end
	self.world = {
		levels = {},
	}
	-- structure
	-- world
	-- |- level
	--    |- layers
	--       |- gridTiles
	--       |- entityInstances
	local world_data = decode_json(world_file)
	for _, level_data in pairs(world_data.levels) do
		local level = {
			id = level_data.iid,
			name = level_data.identifier,
			x = level_data.worldX,
			y = level_data.worldY,
			width = level_data.pxWid,
			height = level_data.pxHei,
			xx = level_data.worldX + level_data.pxWid,
			yy = level_data.worldY + level_data.pxHei,
			tiles = {},
			entities = {},
		}
		self.world.levels[level.name] = level
		for i, layer in ipairs(level_data.layerInstances) do
			local collider = false
			local z_index = -i
			if layer.__identifier:sub(-6) == "_Upper" then
				z_index = level.yy - i
			end
			if layer.__identifier:sub(-9) == "_Collider" then
				collider = true
			end
			if layer.autoLayerTiles then
				for _, tile in pairs(layer.autoLayerTiles) do
					table.insert(level.tiles, {
						x = tile.px[1],
						y = tile.px[2],
						z_index_ofset = z_index,
						image_number = tile.t + 1,
						img_x = tile.src[1],
						img_y = tile.src[2],
						collider = collider,
					})
				end
			end
			if layer.gridTiles then
				for _, tile in pairs(layer.gridTiles) do
					table.insert(level.tiles, {
						x = tile.px[1],
						y = tile.px[2],
						z_index_offset = z_index,
						image_number = tile.t + 1,
						img_x = tile.src[1],
						img_y = tile.src[2],
						collider = collider,
					})
				end
			end
		end
	end
end

function WorldLoaderSystem:init()
	decode_world(self, PATH .. "world.ldtk")
	self:register_events(WorldLoaderSystem.EVENTS)
end

function WorldLoaderSystem:load(level_id)
	local level = self.world.levels[level_id]
	self:publish(WorldLoaderSystem.EVENTS.LOAD_LEVEL, level)
	if self.loaded_level == level.id then
		return
	end
	self.loaded_level = level.id
	for _, tile in ipairs(level.tiles) do
		self:publish(WorldLoaderSystem.EVENTS.LOAD_TILE, tile)
	end
	local level = decode_level("Level_0")
	for _, entity in ipairs(level.entities) do
		self:publish(WorldLoaderSystem.EVENTS.LOAD_ENTITY, entity)
	end
	--for _, raw_entity in ipairs(level.entities) do
	--local entities = extract_entities(self, level, raw_entity)
	--for _, entity in ipairs(entities) do
	--self:publish(WorldLoaderSystem.EVENTS.LOAD_ENTITY, entity)
	--end
	--end
end
