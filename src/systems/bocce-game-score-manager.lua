local timer <const> = playdate.timer
class("BocceGameScoreManager").extends()

function BocceGameScoreManager:init(jack_ball, balls)
	self.jack_ball = jack_ball
	self.balls = balls
	self.scored_balls = {}
	for i, _ in ipairs(self.balls) do
		timer.performAfterDelay(i * 1000, function()
			print("scored " .. tostring(i))
			if i == #self.balls then
				self.done = true
			end
		end)
	end
end

function BocceGameScoreManager:update()
	if self:is_done() then
		return
	end
end

function BocceGameScoreManager:is_done()
	return self.done
end
