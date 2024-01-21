class("BaseScene").extends()

function BaseScene:init()
	print("BaseScene.init")
end

function BaseScene:destroy()
	assert(nil, "BaseScene.destroy should be overwritten")
end

function BaseScene:update()
	assert(nil, "BaseScene.update should be overwritten")
end

function BaseScene:setup(payload)
	assert(nil, "BaseScene.setup should be overwritten")
end

function BaseScene:build_payload()
	assert(nil, "BaseScene.build_payload should be overwritten")
end
