local gfx <const> = playdate.graphics
local sprite <const> = playdate.graphics.sprite
class("ScreenTransitionSystem").extends(sprite)

function ScreenTransitionSystem:init()
	ScreenTransitionSystem.super.init(self)
	-- TODO:
	self:setSize(400, 240)
	self:setCenter(0, 0)
	self:moveTo(0, 0)
	self:setAlwaysRedraw(true)
	self:setIgnoresDrawOffset(true)
	self:setZIndex(Z_INDEXES.TRANSITION)
	self:setVisible(false)
	self:add()
end

function ScreenTransitionSystem:update()
	if not self:isVisible() then
		return
	end
	self.draw_height = self.timer.value
end

function ScreenTransitionSystem:start(fn)
	self:setVisible(true)
	self.on_complete = fn
	self.timer = playdate.timer.new(1000, 0, 240, playdate.easingFunctions.inOutQuad)
	playdate.timer.performAfterDelay(1000, function()
		fn()
	end)
	self.timer.reverses = true
	self.timer.repeats = false
	self.timer.timerEndedCallback = function()
		self:setVisible(false)
	end
end

function ScreenTransitionSystem:draw(x, y, width, height)
	print("draw")
	gfx.lockFocus(self.image)
	gfx.setColor(gfx.kColorBlack)
	gfx.fillRect(0, self.height, width, -self.draw_height)
	gfx.unlockFocus()
end
