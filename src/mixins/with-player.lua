class("WithPlayerMixin").extends()

function WithPlayerMixin:get_player()
	return SpriteManagerSingleton.player
end
