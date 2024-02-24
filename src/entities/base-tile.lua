local sprite <const> = playdate.graphics.sprite
class("BaseTile").extends(sprite)
local source_image = playdate.graphics.imagetable.new("images/tileset")

function BaseTile:init(props)
	local x, y, z_index_offset, image_number, level_id =
		props.x, props.y, props.z_index_offset, props.image_number, props.level_id
	BaseTile.super.init(self)
	local image = source_image:getImage(image_number)
	self:setImage(image)
	self:moveTo(x, y)
	self:setCenter(0, 0)
	self:setZIndex(y + (z_index_offset or 0))
	self.level_id = level_id
	self:setUpdatesEnabled(false)
end
