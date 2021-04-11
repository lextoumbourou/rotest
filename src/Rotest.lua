--[[
	Rotest
	A tiny unit test framework for Roblox.

	Version: 1.0.0
]]--


local TEST_MODULE_SUFFIX = '.test'
local PRIVATE_FUNCTION_PREFIX = '_'


function pathIsATestModule(item)
	local suc, res = pcall(function()
		return item:IsA('ModuleScript') and item.Name:sub(-#TEST_MODULE_SUFFIX) == TEST_MODULE_SUFFIX
	end)

	if suc then
		return res
	end

	return false
end

local TestResult = {}

TestResult.__index = TestResult

function TestResult.new()
	local output = {}
	setmetatable(output, TestResult)
	output.startTime = tick()
	output.testsRun = {}
	return output
end

function TestResult:getStats()
	local success = 0
	local failure = 0
	local skipped = 0

	for testModule, data in pairs(self.testsRun) do
		for methodName, methodData in pairs(data) do
			if methodData.err then
				failure = failure + 1
			else
				success = success + 1
			end
		end
	end

	self.failure = failure
	self.success = success
	self.totalTests = success + failure
	self.totalTime = tick() - self.startTime

end

function formatMethodName(name)
	local output = {}
	for char in name:gmatch'.' do
		if string.match(char, "%u") then
			table.insert(output, ' ')
		end

		table.insert(output, char:lower())
	end
	return table.concat(output, '')
end

local TextReport = {}
function TextReport.report(results)
	local outputStrs = {
		'',
		'========== Rotest results =============',
		'',
		("Collected %d tests"):format(results.totalTests),
		'',
	}

	local errors = {}
	for module, moduleData in pairs(results.testsRun) do
		table.insert(outputStrs, ('  %s test:'):format(module.Name:sub(1, #module.Name - #TEST_MODULE_SUFFIX)))
		table.insert(outputStrs, '')

		for methodName, methodData in pairs(moduleData) do
			local timeTaken = methodData.endTime - methodData.startTime
			local marker = 'x'
			if methodData.err then
				marker = '-'
				table.insert(errors, methodData.err)
			end
			table.insert(outputStrs, ('    [%s] %s (%.2f second(s))'):format(marker, formatMethodName(methodName), timeTaken))
		end
		table.insert(outputStrs, '')
	end

	local outputCode = 0
	if #errors > 0 then
		outputCode = 1
		table.insert(outputStrs, "============== FAILURES ====================")
		table.insert(outputStrs, '')
		for _, err in ipairs(errors) do
			table.insert(outputStrs, err)
		end
	end

	table.insert(
		outputStrs,
		('==== %d passed, %d failed in %.2f seconds ===='):format(
		results.success, results.failure, results.totalTime))
	table.insert(outputStrs, '')

	print(table.concat(outputStrs, "\n"))

	return outputCode
end

function isTestMethod(key, member)
	return (
		type(member) == 'function' and
		key:sub(1, #PRIVATE_FUNCTION_PREFIX) ~= PRIVATE_FUNCTION_PREFIX and
		key ~= 'new' and
		key ~= 'teardown'
	)
end

local TestRunner = {}
function TestRunner:run(rootPath: string, reporter)
	local testResult = TestResult.new()

	local successCount = 0
	local errorCount = 0
	local errors = {}

	-- Search for any modules that end in `_test`
	for _, item in pairs(rootPath:GetDescendants()) do
		if pathIsATestModule(item) then
			local sutTable = require(item)
			testResult.testsRun[item] = {}
			for key, member in pairs(sutTable) do
				if isTestMethod(key, member) then
					testResult.testsRun[item][key] = {err=nil, startTime=tick()}

					local testPassed, errorMessage = pcall(function()
						if sutTable.new then
							sutTable = sutTable.new()
						end

						local output = sutTable[key](sutTable)

						if sutTable.teardown then
							sutTable:teardown()
						end
					end)

					if not testPassed then
						testResult.testsRun[item][key]['err'] = errorMessage
					end

					testResult.testsRun[item][key]['endTime'] = tick()

				end
			end
		end
	end

	testResult:getStats()

	return reporter.report(testResult)
end

local Rotest = {}
function Rotest:run(rootPath: string?, config)
	local config = config or {}
	local reporter = config['reporter'] or TextReport
	local rootPath = rootPath or game

	return TestRunner:run(rootPath, reporter)
end

return Rotest