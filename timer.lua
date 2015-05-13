local skynet = require "skynet"

local timer = {}

function timer.new(self)
	local t = {}

	setmetatable(t, self)

	self.__index = self

	return t
end

function timer.init(self, interval)
	if not interval then
		self.interval = 100
	end

	self.timer_idx = 0

	self.callbacks = {}

	self.timer_idxs = {}

	skynet.timeout(self.interval, function()
		self:on_time_out()
	end)
end

function timer.on_time_out(self)
	skynet.timeout(self.interval, function()
		self:on_time_out()
	end)

	local now = os.time()

	local callbacks = self.callbacks[now]

	if not callbacks then
		return
	end

	for idx, f in pairs(callbacks) do
		f()
		self.timer_idxs[idx] = nil
	end

	self.callbacks[now] = nil
end

function timer.register(self, sec, f)
	assert(type(sec) == "number" and sec > 0)

	sec = os.time() + sec

	self.timer_idx = self.timer_idx + 1

	self.timer_idxs[self.timer_idx] = sec

	if not self.callbacks[sec] then
		self.callbacks[sec] = {}
	end

	local callbacks = self.callbacks[sec]

	callbacks[self.timer_idx] = f

	return self.timer_idx
end

function timer.unregister(self, idx)
	local sec = self.timer_idxs[idx]

	if not sec then
		return
	end

	local callbacks = self.callbacks[sec]

	callbacks[idx] = nil

	self.timer_idxs[idx] = nil
end

return timer
