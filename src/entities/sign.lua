class("Sign").extends(BaseEntity)
Sign:implements(TriggerByPlayerMixin)
Sign:implements(BouncingIconMixin)

function Sign:init(x, y)
	Sign.super.init(self, x, y, "images/sign")
	self:setup_icon(ReadIcon, x - self.width / 2, y - self.height / 2)
	self:setTag(COLLIDER_TAGS.TRIGGER)
	self:setCollideRect(0, self.height / 2, self.width, self.height)
end

function Sign:update()
	Sign.super.update(self)
	self.icon:setVisible(false)
	if self:collides_with_player() then
		self.icon:setVisible(true)
	end
end

function Sign:remove()
	self.icon:remove()
	Sign.super.remove(self)
end

function Sign:trigger()
	print("sign trigger")
end
