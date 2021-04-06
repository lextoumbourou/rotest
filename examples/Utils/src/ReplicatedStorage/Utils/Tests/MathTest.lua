game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Math')

local MathUtilTest = {}
function MathUtilTest:testRoundNumbers()
	local numberToRound = 1.5

	local sut = require(game.ReplicatedStorage.Utils.Math)
	local roundedNumber = sut.round(numberToRound)

	assert(roundedNumber == 2, "Number was not rounded correctly")
end

return MathUtilTest
