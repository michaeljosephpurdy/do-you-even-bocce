class("PubSubMixin").extends()

function PubSubMixin:register_events(events)
	if not self.subscriptions then
		self.subscriptions = {}
	end
	if type(events) == "table" then
		for _, name in pairs(events) do
			self.subscriptions[name] = {}
		end
		return
	end
	self.subscriptions[events] = {}
end

function PubSubMixin:subscribe(event, fn)
	table.insert(self.subscriptions[event], fn)
end

function PubSubMixin:publish(event, payload)
	for _, subscription in ipairs(self.subscriptions[event]) do
		subscription(payload)
	end
end
