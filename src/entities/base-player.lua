local gfx <const> = playdate.graphics
class("BasePlayer").extends(BaseEntity)

BasePlayer.TYPES = {
	MAIN = "MAIN",
	JEFF = "JEFF",
}

local TYPE_DATA = {
	[BasePlayer.TYPES.MAIN] = {
		sprite_sheet = gfx.image.new("images/player-small"),
		name = "PlayerOne",
	},
	[BasePlayer.TYPES.JEFF] = {
		sprite_sheet = gfx.image.new("images/other-player-small"),
		name = "Jeff",
	},
}

function BasePlayer:init(type, level_id)
	BasePlayer.super.init(self, nil, nil, nil, level_id)
	assert(BasePlayer.TYPES[type], tostring(type) .. " not a valid BasePlayer.TYPES")
	local data = TYPE_DATA[type]
	assert(data, tostring(type) .. " not found in BasePlayer")
	self.type = type
	for k, v in pairs(data) do
		self[k] = v
	end
	self:setImage(self.sprite_sheet)
	self:setTag(COLLIDER_TAGS.TRIGGER)
end
