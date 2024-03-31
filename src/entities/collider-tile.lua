class("ColliderTile").extends(BaseTile)

function ColliderTile:init(payload)
	ColliderTile.super.init(self, payload)
	self:setCollideRect(0, 0, self.width, self.height)
	self:setTag(COLLIDER_TAGS.OBSTACLE)
	self:setGroups({ COLLIDER_TAGS.OBSTACLE })
	self:setCollidesWithGroups({ COLLIDER_TAGS.PLAYER })
	self:setCollisionsEnabled(true)
end
