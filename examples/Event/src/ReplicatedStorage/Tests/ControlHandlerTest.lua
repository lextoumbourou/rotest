local ControlHandler = require(game.ReplicatedStorage:WaitForChild('ControlHandler'))

function getMocks()
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

	local EventMock = {}
	function EventMock:Fire()
		self.wasFired = true
	end
	return {UserInputService=UserInputServiceMock, ButtonPressedEvent=EventMock}
end

local TestControlHandler = {}
TestControlHandler.__index = TestControlHandler

function TestControlHandler:testEventFiredWhenXIsPressed()
	local deps = getMocks()
	local sut = ControlHandler.new(deps)
	
	sut:run()
	
	deps.UserInputService:fireInputBegan({KeyCode=Enum.KeyCode.X})
	
	assert(deps.ButtonPressedEvent.wasFired, 'Keypress event was not fired')
end

return TestControlHandler
