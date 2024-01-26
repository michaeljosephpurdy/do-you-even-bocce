local sprite <const> = playdate.graphics.sprite
class("BaseTile").extends(sprite)
local source_image = playdate.graphics.imagetable.new("images/tileset")

function BaseTile:init(x, y, z_index_offset, image_number)
	BaseTile.super.init(self)
	local image = source_image:getImage(image_number)
	self:setImage(image)
	self:moveTo(x, y)
	self:setCenter(0, 0)
	self:setZIndex(y + (z_index_offset or 0))
end

function BaseTile:collides_with(other) end
