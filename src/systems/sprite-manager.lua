local sprite_class <const> = playdate.graphics.sprite
class("SpriteManager").extends()
SpriteManager.singleton = true

function SpriteManager:init(props)
	assert(not SpriteManager.instance, "SpriteManager is a singleton, only one should exist")
	SpriteManager.instance = self
	self.sprites_by_levels = {}
	self.tile_size = props.tile_size or 32
	self.update_width = props.update_width or 10
	self.update_height = props.update_height or 5
	self.sprite_marker_coroutine = coroutine.create(function() end)
end

local function sprite_marker_coroutine(self, level_id)
	return coroutine.create(function()
		local sprites = self.sprites_by_levels[level_id]
		local i = 1
		while i <= #sprites do
			local lower_bound_x = self.target_x - self.update_width * self.tile_size
			local upper_bound_x = self.target_x + self.update_width * self.tile_size
			local lower_bound_y = self.target_y - self.update_height * self.tile_size
			local upper_bound_y = self.target_y + self.update_height * self.tile_size
			local sprite = sprites[i]
			if
				sprite.x >= lower_bound_x
				and sprite.x <= upper_bound_x
				and sprite.y >= lower_bound_y
				and sprite.y <= upper_bound_y
			then
				sprite:add()
			else
				sprite:remove()
			end
			i = i + 1
			if i % 4 == 0 then
				coroutine.yield()
			end
			if i > #sprites then
				i = 1
			end
		end
	end)
end
function SpriteManager:disable(entity)
	entity:remove()
end

function SpriteManager:enable(entity)
	entity:add()
end

function SpriteManager:add(sprite)
	assert(sprite.level_id)
	if sprite.is_player then
		self.player = sprite
	end
	-- if a sprite needs to be a singleton, then
	-- whenever we add the sprite, let's also remove
	-- whatever old instance of that sprite is laying around
	-- if sprite.singleton then
	--   for i, active_sprite in ipairs(self.active_sprites) do
	--     if active_sprite.className == sprite.className then
	--     self:remove(active_sprite, i)
	--     end
	--   end
	-- end
	if sprite:isa(sprite_class) then
		sprite:add()
	end
	if sprite.level_id then
		if not self.sprites_by_levels[sprite.level_id] then
			self.sprites_by_levels[sprite.level_id] = {}
		end
		table.insert(self.sprites_by_levels[sprite.level_id], sprite)
	end
end

function SpriteManager:purge_level(level_id)
	sample("purge_level", function()
		for _, sprite in ipairs(self.sprites_by_levels[level_id] or {}) do
			if sprite.level_id == level_id then
				sprite:remove()
			end
		end
		self.sprites_by_levels[level_id] = {}
	end)
end

function SpriteManager:remove(entity, i)
	local level_id = entity.level_id
	-- if an index is passed in, just remove the sprite
	-- don't worry about traversing the active_sprites table
	if i then
		if entity:isa(sprite_class) then
			entity:remove()
		end
		table.remove(self.sprites_by_levels[level_id], i)
		return
	end
	for i, active_sprite in ipairs(self.sprites_by_levels[level_id]) do
		if active_sprite == entity then
			self:remove(entity, i)
			return
		end
	end
end

function SpriteManager:update()
	sprite_class.update()
	coroutine.resume(self.sprite_marker_coroutine)
end

function SpriteManager:calculate_visible(level_id, x, y)
	self.target_x = x
	self.target_y = y
	local status = coroutine.status(self.sprite_marker_coroutine)
	if status == "dead" then
		self.sprite_marker_coroutine = sprite_marker_coroutine(self, level_id)
	end
end

function SpriteManager:count()
	local total = 0
	for k, tbl in pairs(self.sprites_by_levels) do
		total = total + #tbl
		print(k .. ": " .. #tbl)
	end
	print("total: " .. total)
end
