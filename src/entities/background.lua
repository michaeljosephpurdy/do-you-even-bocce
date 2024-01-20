local gfx <const> = playdate.graphics
class("Background").extends(gfx.sprite)

function Background:init(image_source, level_id)
	Background.super.init(self)
	self:setImage(gfx.image.new(image_source))
	self:moveTo(0, 0)
	self:setCenter(0, 0)
	self.level_id = level_id
end
