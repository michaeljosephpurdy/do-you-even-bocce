class("SceneManager").extends()
SceneManager.singleton = true

function SceneManager:init()
	self.scenes = {}
	self.scene = nil
	self.previous_scene = nil
end

function SceneManager:add_scene(scene_object)
	assert(
		scene_object:isa(BaseScene),
		"Only instances of BaseScene can be added to SceneManager" .. tostring(scene_object)
	)
	for _, existing_scene in pairs(self.scenes) do
		assert(not existing_scene:isa(scene_object), "BaseScene objects should be singletons")
	end
	table.insert(self.scenes, scene_object)
end

function SceneManager:update()
	self.scene:update()
end

function SceneManager:next_scene(scene)
	local found = false
	for _, existing_scene in pairs(self.scenes) do
		if existing_scene.className == scene.className then
			scene = existing_scene
			found = true
		end
	end
	assert(found, "cannot transition to unknown scene: " .. scene.className)
	self.previous_scene = self.scene
	local payload = {}
	if self.previous_scene then
		payload = self.previous_scene:build_payload()
		payload.source = self.previous_scene
		self.previous_scene:destroy()
	end
	self.scene = scene
	self.scene:setup(payload)
	print("SceneManager transitioned to " .. self.scene.className)
end
