local module = {}

--[[
 saveMigrate

Created by aaaaaaaaaaaaalice/weebweeb

saveMigrate is a centralized saving module intended to make transition between legacy Datastore and DataStore2 save systems as 
painless as possible and with minimal data loss

All the functions are created to best blend with existing legacy datastore functions

This file is to be imported to roblox as a ModuleScript

refer to this documentation for information:
https://docs.google.com/document/d/1be5SeX8NIjf4tC1ik21ueiGSpGJtTCaS7KDK77rAjF8/edit#heading=h.7f27m6753px1
--]]

DataStore2 = require(1936396537)
DS = game:GetService("DataStoreService")
verboseOutput = true -- enable this for detailed output of saving and loading actions



--[[
DataStore2.PatchGlobalSettings({
    SavingMethod = "Standard", -- this saving method is suggested for migrating
})
--]]
local function determineSaveMethod(Player, Key, Store)
	local load
	local success, fail = pcall(function()
		load = DataStore2(Key, Player)
		load = load:Get(nil, false)
		if load ~= nil then
			if verboseOutput then
			warn("Loading data from DataStore2: "..tostring(unpack(load)))
			end
		end
	end)
	if load == nil then -- it's not saved with DataStore2, load from legacy Datastore
		if Store ~= nil then
		load = Store:GetAsync(Key)
		if verboseOutput then
		warn("Loading data from legacy datastore: "..tostring(load))
		end
		else
			warn("saveMigrate: no data exists, returning nil")
		end
	end
	if load == nil then
	warn("saveMigrate: no data exists, returning nil")
	end
	return load
end


function module:SetAsync(Key, Value, Store,Player) -- we're gonna abstract the hell out of some savedata
	if Player then
		local success, failure = pcall(function()
		local sd = DataStore2(Key, Player)
		sd:Set(Value)
		sd:Save()
		if verboseOutput then
		warn("Data Saved and successfully migrated to DataStore2: "..tostring(Key)..","..tostring(Value))
		end
		end)
		if not success then warn("saveMigrate failure: "..failure) return nil end
		return Value

	else
		if Store then
			if verboseOutput then
			warn("Could not save data to DataStore2, saving to legacy datastore: "..tostring(Key)..","..tostring(Value))
			end
			local success, failure = pcall(function()
			Store:SetAsync(Key, Value)
			end)
			if not success then warn("saveMigrate failure: "..failure) return nil end
			return Value
		else
			warn("saveMigrate failure: Store == nil!")
			return nil
		end
	end
end

function module:GetAsync(Key,Store,Player)
	local loaddata = determineSaveMethod(Player, Key, Store)
	return loaddata
	
end

saveMigrate = 
{
new = function(name, scope, player) 
local t = {}
	t.store = nil
		if name then
			t.store = DS:GetDataStore(name, scope)
		end
		
		
		
		function t:RemoveAsync(Key)
			local Value = module:GetAsync(Key,t.store,player)
			local val = module:SetAsync(Key, "", t.store, player)
			return Value
		end
		
		function t:IncrementAsync(Key ,delta)
			local changedValue
			local success, failure = pcall(function()
			local Value = module:GetAsync(Key,t.store,player)
			changedValue = module:SetAsync(Key, tonumber(Value) + delta, t.store, player)
			end)
			if not success then warn("saveMigrate failure: "..failure) end
			return changedValue
		end
		function t:SetAsync(Key, Value)
			local load = module:SetAsync(Key, Value, t.store, player)
			return load
		end
	
		function t:GetAsync(Key)
			local load = module:GetAsync(Key,t.store,player)
			return load
		end
		
		function t:UpdateAsync(Key, fun)
			local Value
			if fun == nil then if verboseOutput then warn("fun == nil!, returning nil") end return nil end
			local NewValue
			local SavedValue
			local function retry(Key, fun)
				Value = module:GetAsync(Key,t.store,player)
				NewValue = fun(Value)
				local success, failue = pcall(function()
				 SavedValue = module:SetAsync(Key, NewValue, t.store, player)
				end)
				if success then
					if verboseOutput then
					warn("Value successfully updated")
					end
					return SavedValue
				else
					if verboseOutput then
						warn("Value failed to update, retrying in 30ms")
						warn("Update fail reason: "..tostring(failue))
					end
					wait(1/2)
					return retry(Key, fun)
				end
				
			end
			local returnval = retry(Key,fun)
			return returnval
		end
		
		
return t
end



}

function module:GetDataStore(name, scope, player)
	return saveMigrate.new(name, scope, player)
end





return module
