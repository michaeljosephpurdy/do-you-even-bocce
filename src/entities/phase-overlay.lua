local gfx <const> = playdate.graphics
class("PhaseOverlay").extends(gfx.sprite)

function PhaseOverlay:init()
	PhaseOverlay.super.init(self)
	self:setImage(gfx.image.new("images/overlay-power-phase"))
	self:setCenter(0, 0)
	self:moveTo(0, -self.height)
	self.animation = playdate.graphics.animator.new(1000, self.y, 0, playdate.easingFunctions.outQuad)
end

function PhaseOverlay:update()
	self:moveTo(self.x, self.animation:currentValue())
	if self.pending_removal and self.animation:ended() then
		gfx.sprite.remove(self)
	end
end

function PhaseOverlay:remove()
	self.pending_removal = true
	self.animation = playdate.graphics.animator.new(1500, self.y, -self.height, playdate.easingFunctions.outQuad)
end

class("PositionPhaseOverlay").extends(PhaseOverlay)
function PositionPhaseOverlay:init()
	PositionPhaseOverlay.super.init(self)
	self:setImage(gfx.image.new("images/overlay-position-phase"))
end

class("DirectionPhaseOverlay").extends(PhaseOverlay)
function DirectionPhaseOverlay:init()
	DirectionPhaseOverlay.super.init(self)
	self:setImage(gfx.image.new("images/overlay-direction-phase"))
end

class("PowerPhaseOverlay").extends(PhaseOverlay)
function PowerPhaseOverlay:init()
	PowerPhaseOverlay.super.init(self)
	self:setImage(gfx.image.new("images/overlay-power-phase"))
end
