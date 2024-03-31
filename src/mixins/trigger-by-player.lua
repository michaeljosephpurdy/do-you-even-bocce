class("TriggerByPlayerMixin").extends()

function TriggerByPlayerMixin:collides_with_player()
	-- TODO: Watch for this call to overlapping sprites
	for _, entity in ipairs(self:overlappingSprites()) do
		if entity.is_player then
			entity.target = self
			return true
		end
	end
	return false
end
