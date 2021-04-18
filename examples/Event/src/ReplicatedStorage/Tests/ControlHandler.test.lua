local ControlHandler = require(game.ReplicatedStorage:WaitForChild('ControlHandler'))

function getMocks()
	
end


local TestControlHandler = {}
TestControlHandler.__index = TestControlHandler

function TestControlHandler:_getUserInputMock()
	-- Create user input service mocks.
	local UserInputServiceMock = {}
	UserInputServiceMock.InputBegan = {inputBeganCallbacks={}}
	function UserInputServiceMock.InputBegan:Connect(callback)
		table.insert(self.inputBeganCallbacks, callback)

		-- Also Mock Disconnect functionality.
		return {Disconnect=function(self)
			local newCallbacks = {}
			for i, cb in pairs(self.inputBeganCallbacks) do
				if cb ~= callback then
					table.insert(newCallbacks, cb)
				end
			end
			self.inputBeganCallbacks = newCallbacks
		end}
	end

	function UserInputServiceMock:fireInputBegan(...)
		for _, cb in pairs(self.InputBegan.inputBeganCallbacks) do
			cb(...)
		end
	end

	return UserInputServiceMock
end

function TestControlHandler:_getButtonPressedEvent()
	self.buttonPressedEvent = Instance.new('BindableEvent')
	self.buttonPressedEvent.Name = 'ButtonPressedEvent'

	self.callback = self.buttonPressedEvent.Event:Connect(function()
		self.wasFired = true
	end)

	return self.buttonPressedEvent
end

function TestControlHandler:teardown()
	if self.callback then
		self.callback:Disconnect()
	end

	if self.buttonPressedEvent then
		self.buttonPressedEvent:Destroy()
	end
end

function TestControlHandler:eventFiredWhenXIsPressed()
	local userInputMock = self:_getUserInputMock()
	local sut = ControlHandler.new({
		UserInputService=userInputMock,
		ButtonPressedEvent=self:_getButtonPressedEvent()
	})
	sut:run()
	
	userInputMock:fireInputBegan({KeyCode=Enum.KeyCode.X})
	
	assert(self.wasFired, 'Keypress event was not fired')
end

return TestControlHandler
