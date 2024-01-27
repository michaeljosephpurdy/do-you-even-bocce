local sprite_class <const> = playdate.graphics.sprite
class("SpriteManager").extends()
SpriteManager.singleton = true

function SpriteManager:init()
	assert(not SpriteManager.instance, "SpriteManager is a singleton, only one should exist")
	SpriteManager.instance = self
	self.active_sprites = {}
	self.inactive_sprites = {}
end

function SpriteManager:map(fn)
	for _, sprite in pairs(self.active_sprites) do
		fn(sprite)
	end
end

function SpriteManager:disable(entity)
	entity:remove()
end

function SpriteManager:enable(entity)
	entity:add()
end

function SpriteManager:add(sprite)
	if sprite.is_player then
		self.player = sprite
	end
	-- if a sprite needs to be a singleton, then
	-- whenever we add the sprite, let's also remove
	-- whatever old instance of that sprite is laying around
	if sprite.singleton then
		for i, active_sprite in ipairs(self.active_sprites) do
			if active_sprite.className == sprite.className then
				self:remove(active_sprite, i)
			end
		end
	end
	table.insert(self.active_sprites, sprite)
	if sprite:isa(sprite_class) then
		sprite:add()
	end
end

function SpriteManager:remove_all()
	for i, active_sprite in ipairs(self.active_sprites) do
		print(active_sprite.className)
		if active_sprite:isa(sprite_class) then
			active_sprite:remove()
		end
		table.remove(self.active_sprites, i)
	end
end

function SpriteManager:remove_all_of_type(type)
	for i, active_sprite in ipairs(self.active_sprites) do
		if active_sprite:isa(type) then
			active_sprite:remove()
		end
		table.remove(self.active_sprites, i)
	end
end

function SpriteManager:remove(entity, i)
	-- if an index is passed in, just remove the sprite
	-- don't worry about traversing the active_sprites table
	if i then
		if entity:isa(sprite_class) then
			entity:remove()
		end
		table.remove(self.active_sprites, i)
		return
	end
	for i, active_sprite in ipairs(self.active_sprites) do
		if active_sprite == entity then
			self:remove(entity, i)
			return
		end
	end
end

function SpriteManager:lazy_remove(entity)
	table.insert(self.inactive_sprites, entity)
end

function SpriteManager:lazy_remove_all()
	self.inactive_sprites = {}
	for _, entity in ipairs(self.active_sprites) do
		self:lazy_remove(entity)
	end
end

function SpriteManager:update()
	-- lazy removal of inactive sprites
	for i, _ in ipairs(self.inactive_sprites) do
		local old_sprite = table.remove(self.inactive_sprites, i)
		self:remove(old_sprite)
		break
	end
	sprite_class.update()
	--local colliding_sprites = sprite_class.allOverlappingSprites()
	--for i = 1, #colliding_sprites do
	--local collision_pair = colliding_sprites[i]
	--local a = collision_pair[1]
	--local b = collision_pair[2]
	--a:collides_with(b)
	--b:collides_with(a)
	--end
end

function SpriteManager:count()
	print("active: " .. #self.active_sprites)
	print("inactive: " .. #self.inactive_sprites)
end
