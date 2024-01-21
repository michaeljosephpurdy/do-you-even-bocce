class("BaseEntity").extends(playdate.graphics.sprite)

function BaseEntity:init()
	BaseEntity.super.init(self)
end

function BaseEntity:fix_draw_order()
	local z_index = math.floor(self.y + self.height / 2)
	if self:getZIndex() == z_index then
		return
	end
	self:setZIndex(z_index)
	if self.input_meter then
		self.input_meter:setZIndex(z_index - 1)
	end
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
