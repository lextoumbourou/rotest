game.ServerScriptService:WaitForChild('Userdata')


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

	self.dsMock = DatastoreMock.new()

	local Userdata = require(game.ServerScriptService.Userdata)
	self.sut = Userdata.new(self.dsMock)

	return self
end

function UserDataTest:teardown()
	self.dsMock = nil
	self.sut = nil
end

function UserDataTest:testLoadData()
	self.sut:load(1234)

	assert(self.sut:get(1234).name == "lex", "Data did not load successfully.")
end

function UserDataTest:testPersistData()

	self.sut:load(1234)
	self.sut:persist(1234)

	assert(
		self.dsMock.callCount.UpdateAsync == 1, "UpdateAsync was not called.")
end


return UserDataTest
