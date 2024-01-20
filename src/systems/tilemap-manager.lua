local file <const> = playdate.file
local BASE_PATH = "data/tilemap/world/simplified/"

class("TileMapManager").extends()
TileMapManager.singleton = true

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
	return level
end

local function transition_to(self, level_id)
	local level = decode_level(level_id)
	for _, image_path in ipairs(level.layers) do
		local layer_sprite = Background(image_path, level_id)
		SpriteManagerSingleton:add(layer_sprite)
	end
	self.active_level = level_id
end

function TileMapManager:init()
	transition_to(self, "Level_0")
end
