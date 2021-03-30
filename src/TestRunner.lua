--!strict

local TestRunner = {}

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

function TestRunner:run(rootPath: string?)
	local rootPath = rootPath or game
	
	local successCount = 0
	local errorCount = 0
	local errors = {}
	
	-- Search for any modules that end in `_test`
	for _, item in pairs(rootPath:GetDescendants()) do
		if pathIsATestModule(item) then
			local sutTable = require(item)
			
			for key, member in pairs(sutTable) do
				if type(member) == 'function' and key:sub(1, #TEST_FUNCTION_PREFIX) == TEST_FUNCTION_PREFIX then
					if sutTable.new then sutTable = sutTable.new() end
					local testPassed, errorMessage = pcall(sutTable[key])
					if not testPassed then
						errorCount = errorCount + 1
						table.insert(errors, errorMessage)
					else
						successCount = successCount + 1
					end
					
				end
			end 
		end
	end
	
	-- Print all errors
	print('Number of success: '..successCount..', number of failures: '..errorCount)
	for i, err in ipairs(errors) do
		print(err)
	end
end

return TestRunner
