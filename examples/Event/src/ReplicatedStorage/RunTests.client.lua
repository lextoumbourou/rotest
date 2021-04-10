-- Automatically run client-side tests within Studio.
local RunService = game:GetService("RunService")
if RunService:IsStudio() then
	game:WaitForChild('ReplicatedStorage')
	game.ReplicatedStorage:WaitForChild('RoUnit')

	require(game.ReplicatedStorage.RoUnit):run()
end
