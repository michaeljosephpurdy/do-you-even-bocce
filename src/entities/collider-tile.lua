class("ColliderTile").extends(BaseTile)

function ColliderTile:init(x, y, z_index_offset, image_number)
	ColliderTile.super.init(self, x, y, z_index_offset, image_number)
	self:setCollideRect(0, 0, self.width, self.height)
	self:setTag(COLLIDER_TAGS.OBSTACLE)
end
