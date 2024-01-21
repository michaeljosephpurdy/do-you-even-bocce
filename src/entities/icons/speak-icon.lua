class("SpeakIcon").extends(playdate.graphics.sprite)

function SpeakIcon:init(x, y)
	SpeakIcon.super.init(self)
	self:setImage(playdate.graphics.image.new("images/speak-icon"))
	self.start_x, self.start_y = x, y
	self:moveTo(x, y)
	self.animation = playdate.graphics.animator.new(750, -5, 8, playdate.easingFunctions.inQuad)
	self.animation.reverses = true
	self.animation.repeatCount = -1
end

function SpeakIcon:update()
	self:moveTo(self.x, self.start_y + self.animation:currentValue())
end
