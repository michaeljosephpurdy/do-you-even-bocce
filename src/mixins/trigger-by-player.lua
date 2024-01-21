class("TriggerByPlayerMixin").extends()

function TriggerByPlayerMixin:collides_with_player()
	for _, entity in ipairs(self:overlappingSprites()) do
		if entity.is_player then
			return true
		end
	end
	return false
end
