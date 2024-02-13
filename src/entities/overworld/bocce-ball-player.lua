class("OverworldBocceBallPlayer").extends(BasePlayer)
OverworldBocceBallPlayer:implements(TriggerByPlayerMixin)

function copy_fields(target, source, fields)
	for field in ipairs(fields) do
		target[field] = source[field]
	end
end

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
	self.games_played = 0
	self.games_lost = 0
	self.games_won = 0
end

function OverworldBocceBallPlayer:remove()
	self.icon:remove()
	OverworldBocceBallPlayer.super.remove(self)
end

function OverworldBocceBallPlayer:update()
	OverworldBocceBallPlayer.super.update(self)
	self.icon:setVisible(false)
	if self:collides_with_player() then
		self.icon:setVisible(not self.triggered)
	end
end

function OverworldBocceBallPlayer:player_won(other)
	self.games_lost = self.games_lost + 1
	other.interacting_with = self
	other.lock_controls = true
	self.triggered = true
	DialogueSystemSingleton:queue({ name = self.name, text = self.props.player_win_talk }, function()
		other.lock_controls = false
		self.triggered = false
	end)
	for k, v in pairs(self.props.on_player_win) do
		other[k] = v
	end
end

function OverworldBocceBallPlayer:player_lost(other)
	self.games_won = self.games_won + 1
	other.interacting_with = self
	other.lock_controls = true
	self.triggered = true
	self.won = true
	DialogueSystemSingleton:queue({ name = self.name, text = self.props.player_lose_talk }, function()
		other.lock_controls = false
		self.triggered = false
	end)
	for k, v in pairs(self.props.on_player_lose) do
		other[k] = v
	end
end

function OverworldBocceBallPlayer:trigger(other)
	if self.triggered then
		return
	end
	self.triggered = true
	self.interacting_with = other
	other.interacting_with = self
	other.lock_controls = true
	local text = self.props.intro_talk
	if self.games_played > 0 then
		if self.games_won > self.games_lost then
			text = self.props.rematch_talk
		else
			text = self.props.regular_talk
		end
	end
	DialogueSystemSingleton:queue({ name = self.name, text = text }, function()
		DialogueSystemSingleton:purge()
		other.lock_controls = false
		self.triggered = false
	end, function()
		SceneManagerSingleton:next_state(BocceGameScene)
		self.games_played = self.games_played + 1
	end)
end
