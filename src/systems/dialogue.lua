local gfx <const> = playdate.graphics
class("DialogueSystem").extends(gfx.sprite)

function DialogueSystem:init()
	DialogueSystem.super.init(self)
	self.dialogue = {}
	self:setSize(360, 100)
	self:setCenter(0, 0)
	self:moveTo(20, 120)
	self:setIgnoresDrawOffset(true)
	self:setZIndex(Z_INDEXES.DIALOGUE)
	self:setVisible(false)
	self.border = gfx.nineSlice.new("images/dialogue-nine-slice", 32, 32, 32, 32)
	self:add()
end

function DialogueSystem:update()
	if self.current then
		self:markDirty()
		self:setVisible(true)
		if playdate.buttonJustReleased(playdate.kButtonA) then
			self.text_counter = self.text_counter + 1
			if self.text_counter > #self.current.text then
				self.current.on_accept()
				self.current = nil
			end
		elseif playdate.buttonJustReleased(playdate.kButtonB) then
			self.current.on_reject()
			self.current = nil
		end
	elseif self.dialogue[1] then
		self.current = table.remove(self.dialogue, 1)
		self.text_counter = 1
	else
		self:setVisible(false)
	end
end

function DialogueSystem:queue(texts, on_accept, on_reject)
	local new_dialogue = {
		text = {},
	}
	for _, text in ipairs(texts) do
		table.insert(new_dialogue.text, text)
	end
	new_dialogue.on_accept = on_accept or function() end
	new_dialogue.on_reject = on_reject or function() end
	table.insert(self.dialogue, new_dialogue)
end

function DialogueSystem:draw(x, y, width, height)
	print("drawing")
	gfx.lockFocus(self.image)
	self.border:drawInRect(x, y, width, height)
	if self.current and self.current.text[self.text_counter] then
		gfx.drawText(self.current.text[self.text_counter], 20, 20)
	end
	gfx.unlockFocus()
end
