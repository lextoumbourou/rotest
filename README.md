# Rotest

A unit test framework for Roblox.

<img
    src="https://user-images.githubusercontent.com/1080552/115104581-ca23f200-9f9c-11eb-91c5-eeffa549f4fc.png"
    alt="A screenshot of an example run within Roblox Studio."
    width="600">

## Features

* Writes tests using simple [ModuleScripts](https://developer.roblox.com/en-us/api-reference/class/ModuleScript).
* One-file runner deployment.
* Readable and configurable output.

## Installation

It's just one file, so you can copy the contents of **src/Rotest.lua** into a ModuleScript in **game.ReplicatedStorage**.

---

You can also install using the package under **release/rotest.rbxmx**:

  * Inside Roblox Studio right-click on Workspace and click on **Insert from file…**.
  * Browse to **release/rotest.rbxmx** and Open.
  * Then move **Rotest/Rotest** to **game.ReplicatedStorage**.

## Running tests

1. Start Server.
2. Open Command Bar.
3. Run the following command: ```require(game.ReplicatedStorage.Rotest):run()```

Tests can be run via the command-line using [run-in-roblox](https://github.com/rojo-rbx/run-in-roblox).

## Writing tests

* Tests are just [ModuleScripts](https://developer.roblox.com/en-us/api-reference/class/ModuleScript) whose name ends with `.test`.

* Any methods in the test will be ran in the suite. Prefix private methods with ` _ ` to prevent running.

* If you use `camelCase` for the test names, they will be turned into `camel case` for readability in the output.

* If you have a constructor method called `new()` it will be ran before each test.

* If you have a teardown method called `teardown()` it will be ran after each test.

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

We can then start a Server and call the test runner:

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

## Arguments

The `run(basepath, config)` method takes 2 argument:

* `basepath` - is the base path that the test runner will use to search for tests.
* `config` - a table can have the following keys:
  * `verbose` - a boolean that specifies whether the runner should include every test in the output. Defaults to `true`

## Run on server start

You can automatically run the tests when the server starts, by creating a `ServerScript` like this:

**Game** > **ServerScriptService** > **RunTests**
```
if game:GetService("RunService"):IsStudio() then
        game:WaitForChild('ReplicatedStorage')
        game.ReplicatedStorage:WaitForChild('Rotest')

        require(game.ReplicatedStorage.Rotest):run()
end
```

## More Examples

* [Utils](./examples/Utils) - Example of testing some simple util functions with no side effects.
* [Datastore](./examples/Datastore) - Example of a simple datastore wrapper that loads player data. Shows how to use setup and teardown.
* [Event](./examples/Event) - Example of a simple event handler. Includes a fairly sophisticated mock.

## Why another unit test framework?

* Provides an an alternative to BDD-style tests in [TestEz](https://github.com/Roblox/testez) and [TestSuite](https://devforum.roblox.com/t/testsuite-description/278580).
* Tests are designed to be written as Lua modules with no imports unlike [Nexus-Unit-Testing](https://github.com/TheNexusAvenger/Nexus-Unit-Testing) (which is great).
