# Rotest

A tiny unit test framework for Roblox.

## Features

* One-file deployment.
* Write tests using standard Lua modules.
* Very readable output.

## Installation

Copy `src/Rotest.lua` into a ModuleScript in `game.ReplicatedStorage`.

## Running tests

1. Start Server.
2. Open Command Bar.
3. Run the following command: ```require(game.ReplicatedStorage.Rotest):run()```

## Example

Let's say you have a `ModuleScript` that exposes a single function to round a number:

**ReplicatedStorage** > **MathUtil**

```
local Math = {}
function Math.round(numberToRound)
    return math.floor(numberToRound + 0.5)
end

return Math
```

We can create a test for it by creating another `ModuleScript` with  `.test` suffix. I also have created a **Tests** folder to store all my tests.

**ReplicatedStorage** > **Tests** > **Math.test**

```
game.ReplicatedStorage:WaitForChild('MathUtil')
local MathUtil = require(game.ReplicatedStorage.MathUtil)

local MathUtilTest = {}
function MathUtilTest:roundsNumbersUp()
	local numberToRound = 1.5

	local roundedNumber = MathUtil.round(numberToRound)

	assert(roundedNumber == 2, "Number not rounded up")
end

function MathUtilTest:roundsNumbersDown()
	local numberToRound = 1.1

	local roundedNumber = MathUtil.round(numberToRound)

	assert(roundedNumber == 1, "Number not rounded down")
end

return MathUtilTest
```

Then run the test runner:

`require(game.ReplicatedStorage.Rotest):run()`

It should output something that looks like this:

```
========== Rotest results =============

Collected 2 tests

  Math test:

    [x] rounds numbers up (0.00 second(s))
    [x] rounds numbers down (0.00 second(s))

==== 2 passed, 0 failed in 0.01 seconds ====
```

You could then use a tool like [run-in-roblox](https://github.com/rojo-rbx/run-in-roblox) to run your tests from the command-line.

## Writing tests

* Tests are just normal ModuleScripts whose name ends with `.test`.

* Any methods in the test will be ran in the suite. Prefix private methods with ` _ ` to prevent running.

* If you use `camelCase` for the test names, they will be turned into `camel case` for readability in the output.

* If you have a constructor method called `new()` it will be ran before each test.

* If you have a teardown method called `teardown()` it will be ran after each test.

## Arguments

The `run(basepath, config)` method takes 2 argument:

* `basepath` - is the base path that the test runner will use to search for tests.
* `config` - a table can have the following keys:
  * `verbose` - a boolean that specifies whether the runner should include every test in the output. Defaults to `true`

## More Examples

All tests can be run in Roblox Studio using the `run_tests` command, for example:

```
cd examples/Utils
./run_tests
```

* [Utils](./examples/Utils) - Example of testing some simple util functions with no side effects.
* [Datastore](./examples/Datastore) - Example of a simple datastore wrapper that loads player data. Shows how to use setup and teardown.
* [Event](./examples/Event) - Example of a simple event handler. Includes a fairly sophisticated mock.

## Why another framework?

I wrote this library because I don't always find BDD-style tests - à la [TestEz](https://github.com/Roblox/testez) and others - intutive for all problem domains, especially when testing utility code. I also would prefer to write my tests using the modular, OOP-style Lua that I write most of my production code in.

I also find other projects can be lacking in examples and clear documentation. I'm hoping to do that better.
