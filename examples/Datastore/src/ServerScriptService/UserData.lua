local UserData = {}
UserData.__index = UserData

function UserData.new(datastore)
	local self = {}
	setmetatable(self, UserData)
	
	self.datastore = datastore or game:GetService("DataStoreService"):GetDataStore("RotestUser")
	self.userData = {}
	return self
end

function UserData:load(userId)
	local suc, res = pcall(function()
		return self.datastore:GetAsync("Player_"..userId)
	end)
	if suc then
		self.userData[userId] = res
		return
	end

	error(res)
end

function UserData:get(userId)
	return self.userData[userId]
end

function UserData:persist(userId)
	if self.userData[userId] then
		self.datastore:UpdateAsync("Player_"..userId, function(oldData)
			-- Do validation here.
			return self.userData[userId]
		end)
	end
end

return UserData
