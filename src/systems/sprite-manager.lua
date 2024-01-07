local sprite_class <const> = playdate.graphics.sprite
class("SpriteManager").extends()

function SpriteManager:init()
	assert(not SpriteManager.instance, "SpriteManager is a singleton, only one should exist")
	SpriteManager.instance = self
	self.active_sprites = {}
	self.inactive_sprites = {}
end

function SpriteManager:add(sprite)
	table.insert(self.active_sprites, sprite)
	if sprite:isa(sprite_class) then
		sprite:add()
	end
end

function SpriteManager:remove_all()
	for i, active_sprite in ipairs(self.active_sprites) do
		if active_sprite:isa(sprite_class) then
			active_sprite:remove()
		end
		table.remove(self.active_sprites, i)
	end
end

function SpriteManager:remove(entity)
	for i, active_sprite in ipairs(self.active_sprites) do
		if active_sprite == entity then
			if active_sprite:isa(sprite_class) then
				active_sprite:remove()
			end
			table.remove(self.active_sprites, i)
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
	local collisions = sprite_class.allOverlappingSprites()
	for i = 1, #collisions do
		local collisionPair = collisions[i]
		local sprite1 = collisionPair[1]
		local sprite2 = collisionPair[2]
		--if sprite1:isa(BaseEntity) and sprite2:isa(BaseEntity) then
		--sprite1:collides_with(sprite2)
		--end
	end
	-- lazy removal of inactive sprites
	for i, _ in ipairs(self.inactive_sprites) do
		local old_sprite = table.remove(self.inactive_sprites, i)
		self:remove(old_sprite)
		return
	end
end

return SpriteManager
