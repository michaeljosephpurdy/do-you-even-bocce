local file <const> = playdate.file
local BASE_PATH = "data/tilemap/world/simplified/"

class("WorldLoaderSystem").extends()
WorldLoaderSystem.singleton = true

WorldLoaderSystem.EVENTS = {
	LOAD_LEVEL = "LOAD_LEVEL",
	LOAD_LAYER = "LOAD_LAYER",
	LOAD_ENTITY = "LOAD_ENTITY",
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
	for k, v in pairs(data) do
		print(tostring(k) .. ": " .. tostring(v))
	end
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

function WorldLoaderSystem:init()
	self.subscriptions = {}
	for _, name in pairs(WorldLoaderSystem.EVENTS) do
		self.subscriptions[name] = {}
	end
end

function WorldLoaderSystem:subscribe(event, fn)
	table.insert(self.subscriptions[event], fn)
end

function WorldLoaderSystem:load(level_id)
	local level = decode_level(level_id)
	for _, subscription in ipairs(self.subscriptions[WorldLoaderSystem.EVENTS.LOAD_LEVEL]) do
		subscription({
			x = level.x,
			y = level.y,
			width = level.width,
			height = level.height,
			xx = level.x + level.width,
			yy = level.y + level.height,
		})
	end
	for _, layer in ipairs(level.layers) do
		for _, subscription in ipairs(self.subscriptions[WorldLoaderSystem.EVENTS.LOAD_LAYER]) do
			subscription({
				image_path = layer,
				level_id = level.id,
			})
		end
	end
	for _, entity in ipairs(level.entities) do
		for _, subscription in ipairs(self.subscriptions[WorldLoaderSystem.EVENTS.LOAD_ENTITY]) do
			subscription(entity)
		end
	end
end
