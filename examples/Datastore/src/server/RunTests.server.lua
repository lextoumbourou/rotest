-- Automatically run client-side tests within Studio.
local RunService = game:GetService("RunService")
if RunService:IsStudio() then
	game:WaitForChild('ServerScriptService')
	game.ReplicatedStorage:WaitForChild('Common'):WaitForChild('RoUnit')

	require(game.ReplicatedStorage.Common.RoUnit):run()
end
