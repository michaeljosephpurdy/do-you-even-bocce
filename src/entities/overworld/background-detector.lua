class("BackgroundDetector").extends(playdate.graphics.sprite)

function BackgroundDetector:init(target)
	-- The sole purpose of BackgroundDetector is to...
	-- Detect the Background
	-- This is how we get the camera to lerp to the new background,
	-- by setting the boundaries of the camera to the boundaries of
	-- the background.
	Background.super.init(self)
	self.target = target
	self:moveTo(0, 0)
	self:setSize(1, 1)
	self:setCollideRect(0, 16, self.width, self.height)
	self:setCenter(0, 0)
	self:setUpdatesEnabled(true)
	self:setCollisionsEnabled(true)
	self:setCollidesWithGroups({ COLLIDER_TAGS.BACKGROUND })
	self.level_id = nil
end

function BackgroundDetector:update()
	self:moveTo(self.target.x, self.target.y)
	local _, _, collisions = self:checkCollisions(self.x, self.y)
	if not collisions or not collisions[1] then
		-- This entity should always be colliding with one background sprite
		-- but we'll put this in here just in case
		return
	end
	local other = collisions[1].other
	if self.level_id == other.level_id then
		return
	end
	self.level_id = other.level_id
	CameraSingleton:set_boundaries(other.x, other.x + other.width, other.y, other.y + other.height)
end
