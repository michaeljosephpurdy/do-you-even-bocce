local gfx <const> = playdate.graphics
local timer <const> = playdate.timer
local vector2D <const> = playdate.geometry.vector2D
class("BocceGameScoreManager").extends()

function BocceGameScoreManager:init(jack_ball, balls)
	BocceGameScoreManager.super.init(self)
	self.jack_ball = jack_ball
	local jack_ball_vector = vector2D.new(jack_ball.x, jack_ball.y)
	self.balls = balls
	self.scored_balls = {}

	-- Scoring in bocce ball works like this:
	-- * whoever has a ball closest to the jack ball can score in the round
	-- * that player gets one point per ball that is closer than the other players ball
	-- * the other player gets no points

	-- So, lets start by sorting all the balls by distance to the jack ball
	self.sorted_balls = table.create(#self.balls)
	for _, ball in ipairs(self.balls) do
		local position_vector = vector2D.new(ball.x, ball.y)
		local difference = jack_ball_vector - position_vector
		ball.distance = math.abs(difference:magnitude())
		table.insert(self.sorted_balls, ball)
	end
	table.sort(self.sorted_balls, function(a, b)
		return a.distance < b.distance
	end)

	self.points = 0
	-- we know who won this round by checking the player of the closest ball
	self.winning_player = self.sorted_balls[1].player
	for i, ball in ipairs(self.sorted_balls) do
		if not self.done_scoring and ball.player == self.winning_player then
			self.points = self.points + 1
		end
		if ball.player ~= self.winning_player then
			self.done_scoring = true
		end
		timer.performAfterDelay(i * 1000, function()
			SpriteManagerSingleton:remove(ball)
			ball:remove()
			if i == #self.sorted_balls then
				self.done = true
			end
		end)
	end
	self.winning_player:add_points(self.points)
end

function BocceGameScoreManager:update()
	if self:is_done() then
		return
	end
	gfx.drawText(self.winning_player.name .. " wins " .. self.points .. " points this round!", 50, 180)
end

function BocceGameScoreManager:is_done()
	return self.done
end
