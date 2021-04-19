# Rotest

An easy to use test framework for Roblox.

<p float="left">
<img
    src="https://user-images.githubusercontent.com/1080552/115138734-38d27f80-a071-11eb-9c33-acd2f44b4889.png"
    alt="A screenshot of an example test within Roblox Studio."
    width="500">
<img
    src="https://user-images.githubusercontent.com/1080552/115104581-ca23f200-9f9c-11eb-91c5-eeffa549f4fc.png"
    alt="A screenshot of an example run within Roblox Studio."
    width="400">
</p>

## Features

* Write tests using [ModuleScripts](https://developer.roblox.com/en-us/api-reference/class/ModuleScript) with no dependancies.
* One-file runner deployment.
* Readable and configurable output.

## Installation

It's just one file, so you can copy the contents of **src/Rotest.lua** into a ModuleScript in **game.ReplicatedStorage**.

Or, you can also install using the package under **release/rotest.rbxmx**:

  * Inside Roblox Studio right-click on Workspace and click on **Insert from file**.
  * Browse to **release/rotest.rbxmx** and **Open**.
  * Then move **Rotest/Rotest** to **game.ReplicatedStorage**.

## Running tests

1. Start **Server**.
2. Open **Command Bar**.
3. Run the following command: ```require(game.ReplicatedStorage.Rotest):run()```

Tests can be run via the command-line using [run-in-roblox](https://github.com/rojo-rbx/run-in-roblox).

Each test will be executed in parallel using coroutines.

## Writing tests

* Tests are just [ModuleScripts](https://developer.roblox.com/en-us/api-reference/class/ModuleScript) named to end with `.test`.

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

We can create a test for it by creating another `ModuleScript` called **Math.test** in a **Test** folder.

**ReplicatedStorage** > **Tests** > **Math.test**

```
local MathUtil = require(game.ReplicatedStorage:WaitForChild('MathUtil'))

local MathUtilTest = {}
function MathUtilTest:roundsNumbersUp()
	local numberToRound = 1.5

	local roundedNumber = MathUtil.round(numberToRound)

	assert(roundedNumber == 2, "Number not rounded up")
end

-- Other tests here...

return MathUtilTest
```

We can then start a Server and call the test runner using the **Command Bar**:

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

The main advantage to Rotest over other frameworks is that tests are written simply as Lua modules with no dependancies (injected or otherwise), which means there’s nothing new to learn to start writing tests.

Rotest is similar in spirit to libraries like [PyTest](https://docs.pytest.org/en/6.2.x/) and [xUnit](https://xunit.net/) which utilise more language features rather than framework to write tests.

* Unlike [TestEz](https://github.com/Roblox/testez) and [TestSuite](https://devforum.roblox.com/t/testsuite-description/278580) tests are not written in BDD-style.
* Unlike [Nexus-Unit-Testing](https://github.com/TheNexusAvenger/Nexus-Unit-Testing), tests are designed to be written as Lua modules with no imports

## Who's using it?

We are using it while developing [Splash Music](https://www.roblox.com/games/4936591712/Splash-Music-Skateboards).
