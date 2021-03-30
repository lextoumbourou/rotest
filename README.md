# rounit

A tiny unit test framework and test runner for Roblox

## Installation

Copy TestRunner into a ModuleScript in game.ReplicatedStorage.

## Running tests

1. Start Server
2. Open command-bar.
3. Run the following command: ```require(game.ReplicatedStorage):run()```

## Example

Given a ModuleScript that exposes a single function to round a number:

**game.ReplicatedStorage.MathUtil**
```
local Math = {}
function Math.round(numberToRound)
    return math.floor(numberToRound + 0.5)
end

return Math
```

You can create a test module as follows:

**game.ReplicatedStorage.MathUtilTest**
```
game.ReplicatedStorage:WaitForChild('MathUtils')
local MathUtil = require(game.ReplicatedStorage.MathUtils)

local MathUtilTest = {}
function MathUtilTest:test_round_numbers()
    local numberToRound = 1.5
	
	local roundedNumber = MathUtil.round(numberToRound)
	
	assert roundedNumber == 1
end

return MathUtilTest
```

Then run the test runner.

Since the ModuleScript ends with `Test`, it will search for any functions whose name starts with `test` and execute them catching any errors.

## Setup / Teardown

Setup code can be performed in a constructor called `new`. Each test function is called on a unique instance of the test module.
