class("BaseScene").extends()

function BaseScene:init()
	print("BaseScene.init")
end

function BaseScene:destroy()
	assert("BaseScene.destroy should be overwritten")
end

function BaseScene:update()
	assert("BaseScene.update should be overwritten")
end
