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
		for methodName, methodData in pairs(data.methods) do
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
function TextReport.report(results, config)
	local outputStrs = {
		'',
		'========== Rotest results =============',
		'',
		("Collected %d tests"):format(results.totalTests),
		'',
	}

	local errors = {}
	local hasErrors = false
	for module, moduleData in pairs(results.testsRun) do
		local moduleName = module.Name
		local moduleNumErrors = 0
		local moduleNumSuccess = 0
	
		local verboseOutputStrs = {}
		for methodName, methodData in pairs(moduleData.methods) do
			local marker = 'x'
			if methodData.err then
				hasErrors = true
				marker = '-'
				errors[moduleName..'.'..methodName] = methodData.err
				moduleNumErrors = moduleNumErrors + 1
			else
				moduleNumSuccess = moduleNumSuccess + 1
			end

			table.insert(verboseOutputStrs, ('    [%s] %s (%.2f seconds)'):format(marker, formatMethodName(methodName), methodData.timeTaken))
		end

		local summary = ''
		if not config.verbose then
			summary = ('%i succeeded, %i failed (%.2f seconds)'):format(
				moduleNumSuccess, moduleNumErrors, moduleData.timeTaken)
		end

		table.insert(outputStrs, ('  %s test: %s'):format(moduleName:sub(1, #module.Name - #TEST_MODULE_SUFFIX), summary))

		if config.verbose then
			table.insert(outputStrs, '')
			for i, outputStr in pairs(verboseOutputStrs) do
				 table.insert(outputStrs, outputStr)
			end
			table.insert(outputStrs, '')
		end
	end

	if not config.verbose then
		table.insert(outputStrs, '')
	end

	local outputCode = 0
	if hasErrors then
		outputCode = 1
		table.insert(outputStrs, "============== FAILURES ====================")
		table.insert(outputStrs, '')
		for methodName, err in pairs(errors) do
			table.insert(outputStrs, methodName..': "'..err..'"')
		end
		table.insert(outputStrs, '')
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
function TestRunner:run(rootPath: string, reporter, config)
	local testResult = TestResult.new()

	local successCount = 0
	local errorCount = 0
	local errors = {}

	-- Search for any modules that end in `_test`
	for _, item in pairs(rootPath:GetDescendants()) do
		if pathIsATestModule(item) then
			local sutTable = require(item)
			testResult.testsRun[item] = {methods={}}
			local totalTime = 0
			for key, member in pairs(sutTable) do
				if isTestMethod(key, member) then
					testResult.testsRun[item]['methods'][key] = {err=nil}

					coroutine.wrap(function()
						local startTime = tick()

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
							testResult.testsRun[item]['methods'][key]['err'] = errorMessage
						end

						local endTime = tick()
						local timeTaken = endTime - startTime
						testResult.testsRun[item]['methods'][key]['timeTaken'] = timeTaken
						totalTime = totalTime + timeTaken
					end)()

				end
			end
			testResult.testsRun[item].timeTaken = totalTime
		end
	end

	testResult:getStats()

	return reporter.report(testResult, config)
end

local Rotest = {}
function Rotest:run(rootPath: string?, config)
	local config = config or {verbose=true}
	local reporter = config['reporter'] or TextReport
	local rootPath = rootPath or game

	return TestRunner:run(rootPath, reporter, config)
end

return Rotest
