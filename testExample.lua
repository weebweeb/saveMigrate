--[[
test example of functions, set variable migrationManager to location of saveMigration module.
--]]


migrationManager = require(script.Parent.saveMigrate)
DS = game:GetService("DataStoreService")

data = 2
teststorekey = "tesata12"
teststorename = "aa1a"


game.Players.PlayerAdded:Connect(function(p)

-- before migration

local teststore = DS:GetDataStore(teststorename)
teststore:SetAsync(teststorekey,data)

local success, fail = pcall(function()
print("legacy datastore value "..tostring(teststore:GetAsync(teststorekey)))
end)
if not success then warn(fail) end



local teststore = migrationManager:GetDataStore(teststorename, nil, p)

--getting value
testload = teststore:GetAsync(teststorekey)
print(tostring("load migration value: "..tostring(testload)))

--updating value
testload = teststore:UpdateAsync(teststorekey, function(data) data = data + 1 return data end)
print("datastore2 update value: "..tostring(testload))

--setting value
testload = teststore:SetAsync(teststorekey, 3)
print("datastore2 set migration value: "..tostring(testload))


--incrementing value 
testload = teststore:IncrementAsync(teststorekey, 1)
print("datastore2 increment value: "..tostring(testload))

-- removing using migrationManager

local removedvalue = teststore:RemoveAsync(teststorekey, data)
testload = teststore:GetAsync(teststorekey)
print("datastore2 removing value "..tostring(removedvalue),tostring(testload))

end)
