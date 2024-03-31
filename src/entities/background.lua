local gfx <const> = playdate.graphics
class("Background").extends(gfx.sprite)

function Background:init(payload)
	Background.super.init(self)
	self:setImage(gfx.image.new(payload.image_source))
	self:moveTo(payload.x, payload.y)
	self:setCollideRect(0, 0, self.width, self.height)
	self:setCenter(0, 0)
	self.level_id = payload.level_id
	self:setUpdatesEnabled(false)
	self:setCollisionsEnabled(true)
	self:setZIndex(payload.z_index)
	self.level_uid = payload.level_uid
	self.level_id = payload.level_id
end
