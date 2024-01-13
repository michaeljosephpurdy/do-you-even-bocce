class("SceneManager").extends()

function SceneManager:init()
	self.states = {}
	self.state = nil
	self.previous_state = nil
end

function SceneManager:add_state(state_object)
	assert(
		state_object:isa(BaseScene),
		"Only instances of BaseScene can be added to SceneManager" .. tostring(state_object)
	)
	for _, existing_state in pairs(self.states) do
		assert(not existing_state:isa(state_object), "BaseScene objects should be singletons")
	end
	table.insert(self.states, state_object)
end

function SceneManager:update()
	self.state:update()
end

function SceneManager:next_state(state)
	local found = false
	for _, existing_state in pairs(self.states) do
		print(existing_state)
		if existing_state.className == state.className then
			found = true
		end
	end
	assert(found, "cannot transition to unknown state: " .. state.className)
	self.previous_state = self.state
	if self.previous_state then
		self.previous_state:destroy()
	end
	self.state = state
	self.state:setup()
	print("SceneManager transitioned to " .. self.state.className)
end
