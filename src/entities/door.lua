class("Door").extends(BaseEntity)
Door:implements(TriggerByPlayerMixin)
Door:implements(BouncingIconMixin)

function Door:init(props)
	local x, y = props.x, props.y
	Door.super.init(self, x, y, "images/door", props.level_id)
	self:setTag(COLLIDER_TAGS.TRIGGER)
	self:setCollideRect(0, self.height / 2, self.width, self.height)
	self:fix_draw_order()
	if props.exit then
		self:setup_icon(ExitIcon, x - self.width / 2, y - self.height / 2)
	else
		self:setup_icon(EnterIcon, x - self.width / 2, y - self.height / 2)
	end
	-- doors must go to somewhere
	assert(props.travel_to, "invalid door at (world position) x: " .. x .. " y: " .. y)
	self.linked_level_uid = props.travel_to.levelIid
	local linked_door = WorldLoaderSingleton:get_entity(props.travel_to.entityIid)
	self.linked_x = linked_door.x
	self.linked_y = linked_door.y
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

function Door:trigger(other)
	print("going to " .. self.linked_level_uid)
	print("leaving  " .. self.level_id)
	other.level_id = self.linked_level_uid
	other:moveTo(self.linked_x, self.linked_y)
	WorldLoaderSingleton:load(self.linked_level_uid)
	CameraSingleton:target_sprite_centered(other, 10)
	SpriteManagerSingleton:purge_level(self.level_id)
end
