local ControlHandler = {}
ControlHandler.__index = ControlHandler

function ControlHandler.new(deps)
	local deps = deps or {}

	local self = {}
	setmetatable(self, ControlHandler)
	self.UserInputService = deps.UserInputService or game:GetService("UserInputService")

	if not deps.ButtonPressedEvent then
		local buttonPressedEvent = Instance.new('BindableEvent')
		buttonPressedEvent.Name = 'ButtonPressedEvent'
		buttonPressedEvent.Parent = game.ReplicatedStorage
		deps.ButtonPressedEvent = buttonPressedEvent
	end

	self.ButtonPressedEvent = deps.ButtonPressedEvent

	return self
end

function ControlHandler:run()
	self.inputCb = self.UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.X then
			self.ButtonPressedEvent:Fire()
		end
	end)

	print('Control handler running.')
end

function ControlHandler:stop()
	self.inputCb:Disconnect()
end

return ControlHandler
