game.ServerScriptService:WaitForChild('Server'):WaitForChild('Userdata')


local DatastoreMock = {}
DatastoreMock.__index = DatastoreMock

function DatastoreMock.new()
	local self = {}
	setmetatable(self, DatastoreMock)
	self.callCount = {
		GetAsync=0,
		UpdateAsync=0
	}
	return self
end

function DatastoreMock:GetAsync(userId)
	self.callCount['GetAsync'] = self.callCount['GetAsync'] + 1

	return {name="lex"}
end

function DatastoreMock:UpdateAsync(userId)
	self.callCount['UpdateAsync'] = self.callCount['UpdateAsync'] + 1
end


local UserDataTest = {}
UserDataTest.__index = UserDataTest

function UserDataTest.new()
	local self = {}
	setmetatable(self, UserDataTest)
	return self
end

function UserDataTest:testLoadData()
	local Userdata = require(game.ServerScriptService.Server.Userdata)
	local dsMock = DatastoreMock.new()
	local sut = Userdata.new(dsMock)

	sut:load(1234)

	assert(sut:get(1234).name == "lex", "Data did not load successfully.")
end

function UserDataTest:testPersistData()
	local Userdata = require(game.ServerScriptService.Server.Userdata)
	local sut = require(game.ServerScriptService.Server.Userdata)
	local dsMock = DatastoreMock.new()
	local sut = Userdata.new(dsMock)

	sut:load(1234)
	sut:persist(1234)

	assert(
		dsMock.callCount.UpdateAsync == 1, "UpdateAsync was not called.")
end


return UserDataTest
