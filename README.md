# saveMigrate
saveMigrate is a centralized saving module intended to make transition between legacy Datastore and DataStore2 save systems as painless as possible and with minimal data loss

# Synopsis
New Datastore solutions are too complicated to replace existing datastore entries reliably. This can lead to complete redesigns in code structure and in most cases, loss of data for users. This is not good. A proper solution is a system that can automate the migration of data from one save system to another. In this case this is from Roblox's classic DataStore system to kampfkarren's DataStore2 system. This system facilitates, automates and expedites the process of data migration and hybridization of both datastore methods. This system implements elements from both Datastore2 and legacy Datastore and combines them into one clear, consise wrapper which is both easy to use and implement into existing legacy datastore systems.

# Functions


***Variant* GetAsync(*string* Key, *GlobalDataStore* Store,  *Player* Player, ...)**

  returns Value from Key. Prefers DataStore2, if Player is nil then it will strictly use legacy DataStores. If Store is nil then it will strictly use Datastore2. If both Store and Player are defined, and a DataStore2 does not exist, then it will attempt to load from a legacy Datastore

***Variant* SetAsync(*string* Key, *variant* Value, *GlobalDataStore* Store,  *Player* Player, ...)**
  
  sets Key to Value, prefers Datastore2. if Player is nil then it will strictly use legacy DataStores. If Store is nil then it will strictly use Datastore2. If both Store and Player are defined, and a DataStore2 does not exist, then it will attempt to load from a legacy Datastore

***Instance* GetDataStore(*string* name, *string* scope, *Player* Player, ...)**
  
  Returns a migrationManager instance similar to Roblox's GlobalDataStore instance. Said instance will reference either a GlobalDataStore or a DataStore2 instance depending on the arguments given. If player is undefined then it will strictly use legacy Datastores, if name is undefined then it will strictly use DataStore2. 

However, if both name and Player are given, the module will load from the datastore and save to the Datastore2 when possible under the player object. 

The migrationManager instance will use this data in the functions it returns.





# Instances


# migrationManager

***Variant* migrationManager:getAsync(*string* Key,...)**
  
  returns Value from Key. Prefers DataStore2, uses player, name and scope values from migrationManager instance. 


***Variant* migrationManager:SetAsync(*string* Key, *variant* Value, ...)**
  
  sets Key to Value, prefers Datastore2, uses player, name and scope values from migrationManager instance. 

***Variant* migrationManager:RemoveAsync(*string* Key,  ...)**
  
  Sets the Value of Key to a blank string ("") and returns the value it was set as.  Uses player, name and scope values from migrationManager instance. 


  note: This function cannot set values to nil because of problems that arise with DataStore2 when doing so


***Variant* migrationManager:IncrementAsync(*string* Key, *number* Delta, ...)**
  
  adds Delta to the existing value under Key and returns the changed value. Uses player, name and scope values from migrationManager instance. 



***Variant* migrationManager:UpdateAsync(*string* Key, *callbackFunction* fun, ...)**
  
  This function is functionally the same as GlobalDataStore:UpdateAsync() -

This function will update the value of Key with the new value returned by callback function fun().
Uses player, name and scope values from migrationManager instance. 

Callback function fun() will be called with the value of Key as parameters, expecting a returned value to update the key with.
In the event that the save fails (eg: another server is saving to the datastore at the same time,etc), updateAsync will preform a "Reliable Delivery" - this means it will continue to try to
save the data until it is successful. Once it is successful it will return the updated value.

Notice -
if fun or Key is nil then UpdateAsync will return nil and abort  
fun() should not yield, do not call wait() or delay() when defining it!








