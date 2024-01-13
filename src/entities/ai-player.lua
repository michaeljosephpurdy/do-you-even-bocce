local gfx <const> = playdate.graphics
class("AiPlayer").extends(BasePlayer)

function AiPlayer:init(name, ball_type)
	AiPlayer.super.init(self, name, ball_type)
	self:setImage(gfx.image.new("images/other-player-small"))
	self:moveTo(40, 132)
	self:setAlwaysRedraw(true)
end

function AiPlayer:update()
	if not self.active then
		return
	end
	AiPlayer.super.update(self)
	print("AiPlayer.update")
end

function AiPlayer:deactivate()
	AiPlayer.super.deactivate(self)
	self.active = false
end

function AiPlayer:activate()
	AiPlayer.super.activate(self)
	self.active = true
end

function AiPlayer:is_done()
	return true
end
