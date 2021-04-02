game.ReplicatedStorage:WaitForChild('MathUtil')
local MathUtil = require(game.ReplicatedStorage.MathUtil)

local MathUtilTest = {}
function MathUtilTest:testRoundNumbers()
	local numberToRound = 1.5

	local roundedNumber = MathUtil.round(numberToRound)

	assert(roundedNumber == 2, "Number was not rounded correctly")
end

return MathUtilTest
