local sprite <const> = playdate.graphics.sprite
local image <const> = playdate.graphics.image
class("BaseEntity").extends(sprite)

function BaseEntity:init(x, y, image_path)
	BaseEntity.super.init(self)
	if image_path then
		self:setImage(image.new(image_path))
	end
	if x and y then
		self:moveTo(x, y)
	end
end

function BaseEntity:fix_draw_order()
	local z_index = math.floor(self.y + self.height / 2)
	if self:getZIndex() == z_index then
		return
	end
	self:setZIndex(z_index)
end

function BaseEntity:collides_with(other)
	print("collision! " .. tostring(self) .. " with " .. tostring(other))
	return false
end

function BaseEntity:check_collision(other) end

function BaseEntity:update()
	BaseEntity.super.update(self)
	self:fix_draw_order()
end
