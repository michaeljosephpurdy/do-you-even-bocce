class("BaseEntity").extends(playdate.graphics.sprite)

function BaseEntity:init()
	BaseEntity.super.init(self)
end

function BaseEntity:collides_with(other)
	print("collision! " .. tostring(self) .. " with " .. tostring(other))
end

function BaseEntity:check_collision(other) end
