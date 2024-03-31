local gfx <const> = playdate.graphics
class("DialogueSystem").extends(gfx.sprite)

-- Dialogue system works as follows:
-- Messages are queued by clients and displayed when present
-- Clients have ability to pass in three functions (on_end, on_accept, on_reject)
-- on_end is executed whenever dialogue is over
-- If on_accept and on_reject are passed in, then when final message
-- is displayed, another text box is displayed with `yes` and `no`
-- options, and corresponding functions are called when player selects them
function DialogueSystem:init()
	DialogueSystem.super.init(self)
	self.dialogue = {}
	self:setSize(400, 240)
	self:setCenter(0, 0)
	self:moveTo(0, 0)
	self:setIgnoresDrawOffset(true)
	self:setZIndex(Z_INDEXES.DIALOGUE)
	self.border = gfx.nineSlice.new("images/dialogue-nine-slice", 32, 32, 32, 32)
end

local function next_message(self)
	self.current = table.remove(self.dialogue, 1)
end

function DialogueSystem:update()
	if self.current then
		self:markDirty()
		if self.current.needs_decision then
			if playdate.buttonJustReleased(playdate.kButtonUp) or playdate.buttonJustReleased(playdate.kButtonDown) then
				self.current.accept = not self.current.accept
			end
		end
		if playdate.buttonJustReleased(playdate.kButtonA) then
			if self.current.last_message then
				if self.current.accept and self.current.on_accept then
					self.current.on_accept()
				end
				if self.current.on_end then
					self.current.on_end()
				end
				self:purge()
			end
			next_message(self)
		elseif playdate.buttonJustReleased(playdate.kButtonB) then
			if self.current.needs_decision and self.current.on_reject then
				self.current.on_reject()
			end
			if self.current.on_end then
				self.current.on_end()
			end
			self:purge()
		end
	elseif self.dialogue[1] then
		next_message(self)
	end
end

function DialogueSystem:purge()
	self:remove()
	self.current = nil
	self.dialogue = {}
end

function DialogueSystem:queue(payload, on_end, on_accept, on_reject)
	self:add()
	assert(payload.text)
	local texts = payload.text
	for i, text in ipairs(texts) do
		local new_dialogue = { text = text }
		if payload.name then
			new_dialogue.text = "*" .. payload.name .. "*: " .. text
		end
		new_dialogue.on_end = on_end
		if payload.name then
			new_dialogue.name = payload.name
		end
		if i == #texts then
			new_dialogue.last_message = true
			new_dialogue.on_accept = on_accept
			new_dialogue.on_reject = on_reject
			new_dialogue.needs_decision = on_accept
			new_dialogue.accept = false
			print(new_dialogue.needs_decision)
		end
		table.insert(self.dialogue, new_dialogue)
	end
end

function DialogueSystem:draw(x, y, width, height)
	if not self.current then
		return
	end
	gfx.lockFocus(self.image)
	self.border:drawInRect(x + 20, 140, width - 40, 90)
	gfx.drawText(self.current.text, 40, 155)
	if self.current.needs_decision then
		self.border:drawInRect(330, 160, 64, 50)
		if self.current.accept then
			gfx.drawText("> Yes", 340, 174)
			gfx.drawText("  No", 340, 194)
		else
			gfx.drawText("  Yes", 340, 174)
			gfx.drawText("> No", 340, 194)
		end
	end
	gfx.unlockFocus()
end
