-- Automatically run client-side tests within Studio.
local RunService = game:GetService("RunService")
if RunService:IsStudio() then
	game:WaitForChild('ReplicatedStorage')
	game.ReplicatedStorage:WaitForChild('TestRunner')

	require(game.ReplicatedStorage.TestRunner):run()
end
