class("PubSubMixin").extends()

function PubSubMixin:subscribe(event, fn)
	table.insert(self.subscriptions[event], fn)
end

function PubSubMixin:publish(event, payload)
	for _, subscription in ipairs(self.subscriptions[event]) do
		subscription(payload)
	end
end
