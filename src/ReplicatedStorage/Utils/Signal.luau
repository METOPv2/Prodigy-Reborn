--!nonstrict

local Signal = {}
Signal.__index = Signal

function Signal.new()
	local self = setmetatable({}, Signal)
	self._bind = Instance.new("BindableEvent")
	return self
end

function Signal:Fire(...)
	assert(getmetatable(self) == Signal, "Cannot fire a signal that is not initialized.")
	self._bind:Fire(...)
end

function Signal:Connect(callback)
	assert(callback and typeof(callback) == "function", "Callback must be a function.")
	assert(getmetatable(self) == Signal, "Cannot connect to a signal that is not initialized.")
	return self._bind.Event:Connect(callback)
end

function Signal:Once(callback)
	assert(callback and typeof(callback) == "function", "Callback must be a function.")
	assert(getmetatable(self) == Signal, "Cannot connect to a signal that is not initialized.")
	return self._bind.Event:Once(callback)
end

function Signal:Wait()
	assert(getmetatable(self) == Signal, "Cannot wait on a signal that is not initialized.")
	return self._bind.Event:Wait()
end

function Signal:Destroy()
	assert(getmetatable(self) == Signal, "Cannot destroy a signal that is not initialized.")
	self._bind:Destroy()
	self._bind = nil
	setmetatable(self, nil)
end

return Signal
