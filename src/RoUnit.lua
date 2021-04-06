--[[
	RoUnit
	
	A tiny unit test framework for Roblox.
]]--


local TEST_MODULE_SUFFIX = 'Test'
local TEST_FUNCTION_PREFIX = 'test'


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

local TextReport = {}
function TextReport.report(results)
	local outputStrs = {
		'',
		'========== rounit test results =============',
		'',
		("Collected %d tests"):format(results.totalTests),
		'',
	}

	local errors = {}
	for module, moduleData in pairs(results.testsRun) do
		table.insert(outputStrs, ('  %s'):format(module.Name))
		table.insert(outputStrs, '')

		for methodName, methodData in pairs(moduleData) do
			local timeTaken = methodData.endTime - methodData.startTime
			local marker = 'x'
			if methodData.err then
				marker = '-'
				table.insert(errors, methodData.err)
			end
			table.insert(outputStrs, ('    [%s] %s (%.2f second(s))'):format(marker, methodName, timeTaken))
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
				if type(member) == 'function' and key:sub(1, #TEST_FUNCTION_PREFIX) == TEST_FUNCTION_PREFIX then
					testResult.testsRun[item][key] = {err=nil, startTime=tick()}

					local testPassed, errorMessage = pcall(function()
						if sutTable.new then
							sutTable = sutTable.new()
						end

						return sutTable[key]()
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

local RoUnit = {}
function RoUnit:run(rootPath: string?, config)
	local config = config or {}
	local reporter = config['reporter'] or TextReport
	local rootPath = rootPath or game
	
	return TestRunner:run(rootPath, reporter)
end

return RoUnit
