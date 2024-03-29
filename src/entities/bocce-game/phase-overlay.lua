local gfx <const> = playdate.graphics
class("PhaseOverlay").extends(gfx.sprite)

function PhaseOverlay:init(level_id)
	PhaseOverlay.super.init(self)
	self.level_id = level_id
	self:setImage(gfx.image.new("images/overlay-power-phase"))
	self:setCenter(0, 0)
	self:moveTo(0, -self.height)
	self.animation = playdate.graphics.animator.new(1000, self.y, 0, playdate.easingFunctions.outQuad)
	self:setIgnoresDrawOffset(true)
	self:setZIndex(Z_INDEXES.UI)
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
function PositionPhaseOverlay:init(level_id)
	PositionPhaseOverlay.super.init(self, level_id)
	self:setImage(gfx.image.new("images/overlay-position-phase"))
end

class("DirectionPhaseOverlay").extends(PhaseOverlay)
function DirectionPhaseOverlay:init(level_id)
	DirectionPhaseOverlay.super.init(self, level_id)
	self:setImage(gfx.image.new("images/overlay-direction-phase"))
end

class("PowerPhaseOverlay").extends(PhaseOverlay)
function PowerPhaseOverlay:init(level_id)
	PowerPhaseOverlay.super.init(self, level_id)
	self:setImage(gfx.image.new("images/overlay-power-phase"))
end

class("SpinPhaseOverlay").extends(PhaseOverlay)
function SpinPhaseOverlay:init(level_id)
	SpinPhaseOverlay.super.init(self, level_id)
	self:setImage(gfx.image.new("images/overlay-spin-phase"))
end
