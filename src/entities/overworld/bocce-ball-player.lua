class("OverworldBocceBallPlayer").extends(BasePlayer)

function OverworldBocceBallPlayer:init(type, x, y)
	OverworldBocceBallPlayer.super.init(self, type)
	self:moveTo(x, y)
	self:setCollideRect(-8, 0, self.width + 16, self.height)
	self.speak_icon = SpeakIcon(x - self.width, y - self.height)
	self.speak_icon:setZIndex(self:getZIndex())
	self.speak_icon:add()
end

function OverworldBocceBallPlayer:remove()
	self.speak_icon:remove()
	OverworldBocceBallPlayer.super.remove(self)
end

function OverworldBocceBallPlayer:update()
	OverworldBocceBallPlayer.super.update(self)
	self.speak_icon:setZIndex(self:getZIndex())
	self.speak_icon:setVisible(false)
	for _, entity in ipairs(self:overlappingSprites()) do
		if entity:isa(OverworldControllablePlayer) then
			self.speak_icon:setVisible(true)
		end
	end
end
