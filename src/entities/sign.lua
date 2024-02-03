class("Sign").extends(BaseEntity)
Sign:implements(TriggerByPlayerMixin)
Sign:implements(BouncingIconMixin)

function Sign:init(props)
	local x, y = props.x, props.y
	Sign.super.init(self, props.x, props.y, "images/sign", props.level_id)
	self:setup_icon(ReadIcon, x - self.width / 2, y - self.height / 2)
	self:setTag(COLLIDER_TAGS.TRIGGER)
	self:setCollideRect(0, self.height / 2, self.width, self.height)
	self.props = props
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

function Sign:trigger(other)
	other.lock_controls = true
	if self.triggered then
		return
	end
	DialogueSystemSingleton:queue(self.props.text, function()
		other.lock_controls = false
		self.triggered = false
	end, function()
		other.lock_controls = false
		self.triggered = false
	end)
	self.triggered = true
end
