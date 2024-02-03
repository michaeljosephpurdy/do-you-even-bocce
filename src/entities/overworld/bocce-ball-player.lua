class("OverworldBocceBallPlayer").extends(BasePlayer)
OverworldBocceBallPlayer:implements(TriggerByPlayerMixin)

function OverworldBocceBallPlayer:init(props)
	local type = props.BoccePlayers
	OverworldBocceBallPlayer.super.init(self, type, props.level_id)
	local x, y = props.x, props.y
	self:moveTo(x, y)
	self:setCollideRect(-8, self.height - self.height / 2, self.width + 16, self.height / 2)
	self.icon = SpeakIcon(x - self.width, y - self.height)
	self.icon:setZIndex(Z_INDEXES.ICONS)
	self.icon:add()
	self.props = props
end

function OverworldBocceBallPlayer:remove()
	self.icon:remove()
	OverworldBocceBallPlayer.super.remove(self)
end

function OverworldBocceBallPlayer:update()
	OverworldBocceBallPlayer.super.update(self)
	self.icon:setVisible(false)
	if self:collides_with_player() then
		self.icon:setVisible(true)
	end
end

function OverworldBocceBallPlayer:trigger(other)
	other.lock_controls = true
	DialogueSystemSingleton:queue(self.props.intro_talk, function()
		print("on_accept")
		SceneManagerSingleton:next_state(BocceGameScene)
	end, function()
		print("on_reject")
		other.lock_controls = false
	end)
end
