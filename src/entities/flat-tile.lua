local sprite <const> = playdate.graphics.sprite
class("FlatTile").extends(sprite)
local source_image = playdate.graphics.imagetable.new("images/tileset")

function FlatTile:init(x, y, z_index_offset, image_number, collider)
	FlatTile.super.init(self)
	local image = source_image:getImage(image_number)
	self:setImage(image)
	self:moveTo(x, y)
	self:setCenter(0, 0)
	self:setZIndex(y + (z_index_offset or 0))
	if collider then
		self.collisionResponse = playdate.graphics.sprite.kCollisionTypeFreeze
		self:setCollideRect(0, 0, self.width, self.height)
	end
end

function FlatTile:collides_with(other) end
