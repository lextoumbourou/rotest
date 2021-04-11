game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Math')

local MathTest = {}
function MathTest:roundsNumbers()
	local numberToRound = 1.5

	local sut = require(game.ReplicatedStorage.Utils.Math)
	local roundedNumber = sut.round(numberToRound)

	assert(roundedNumber == 2, "Number was not rounded correctly")
end

return MathTest
