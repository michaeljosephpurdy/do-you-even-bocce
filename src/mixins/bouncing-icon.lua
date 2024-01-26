class("BouncingIconMixin").extends()

function BouncingIconMixin:setup_icon(icon, x, y)
	self.icon = icon(x, y)
	self.icon:setZIndex(Z_INDEXES.ICONS)
	self.icon:add()
end
