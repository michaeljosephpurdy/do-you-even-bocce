local graphics <const> = playdate.graphics
class("BaseIcon").extends(graphics.sprite)

function BaseIcon:init(x, y, image_path)
	BaseIcon.super.init(self)
	self:setImage(graphics.image.new(image_path))
	self.start_x, self.start_y = x, y
	self:moveTo(x, y)
	self.animation = graphics.animator.new(750, -5, 8, playdate.easingFunctions.inQuad)
	self.animation.reverses = true
	self.animation.repeatCount = -1
end

function BaseIcon:update()
	self:moveTo(self.x, self.start_y + self.animation:currentValue())
end

class("SpeakIcon").extends(BaseIcon)
function SpeakIcon:init(x, y)
	SpeakIcon.super.init(self, x, y, "images/speak-icon")
end

class("EnterIcon").extends(BaseIcon)
function EnterIcon:init(x, y)
	EnterIcon.super.init(self, x, y, "images/enter-icon")
end

class("ExitIcon").extends(BaseIcon)
function ExitIcon:init(x, y)
	ExitIcon.super.init(self, x, y, "images/exit-icon")
end

class("ReadIcon").extends(BaseIcon)
function ReadIcon:init(x, y)
	ReadIcon.super.init(self, x, y, "images/read-icon")
end
