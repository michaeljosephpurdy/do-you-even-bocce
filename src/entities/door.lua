class("Door").extends(BaseEntity)
Door:implements(TriggerByPlayerMixin)
Door:implements(BouncingIconMixin)

function Door:init(x, y)
	Door.super.init(self, x, y, "images/door")
	self:setTag(COLLIDER_TAGS.TRIGGER)
	self:setCollideRect(0, self.height / 2, self.width, self.height)
	self:fix_draw_order()
	self:setup_icon(EnterIcon, x - self.width / 2, y - self.height / 2)
end

function Door:update()
	Door.super.update(self)
	self.icon:setVisible(false)
	if self:collides_with_player() then
		self.icon:setVisible(true)
	end
end

function Door:remove()
	self.icon:remove()
	Door.super.remove(self)
end

function Door:trigger()
	print("door trigger")
end
