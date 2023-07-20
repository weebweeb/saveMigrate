# saveMigrate
saveMigrate is a centralized saving module intended to make transition between legacy Datastore and DataStore2 save systems as painless as possible and with minimal data loss. A solid understanding of both DataStore2 and Roblox's DataStore service is expected to understand this documentation.

# Abstract
New Datastore solutions are too complicated to replace existing datastore entries reliably. This can lead to complete redesigns in code structure and in most cases, loss of data for users. This is not good. A proper solution is a system that can automate the migration of data from one save system to another. In this case this is from Roblox's classic DataStore system to kampfkarren's DataStore2 system. This system facilitates, automates and expedites the process of data migration and hybridization of both datastore methods. This system implements elements from both Datastore2 and legacy Datastore and combines them into one clear, consise wrapper which is both easy to use and implement into existing legacy datastore systems.

# Functions


Variant: GetAsync(String: Key, GlobalDataStore: Store,  Player: Player, ...)

  returns a value saved under `Key`. Prefers DataStore2, if `Player` is nil then it will strictly use legacy DataStores. If `Store` is nil then it will strictly use Datastore2. If both `Store` and `Player` are defined, and a DataStore2 does not exist, then it will attempt to load from a legacy Datastore

Variant: SetAsync(String: Key, Variant: Value, GlobalDataStore: Store,  Player: Player, ...)
  
  sets `Key` to `Value`, prefers Datastore2. if `Player` is nil then it will strictly use legacy DataStores. If `Store` is nil then it will strictly use Datastore2. If both `Store` and `Player` are defined, and a DataStore2 does not exist, then it will attempt to load from a legacy Datastore

Instance: GetDataStore(String: name, String: scope, Player: Player, ...)
  
  Returns a `migrationManager` instance similar to Roblox's GlobalDataStore instance. Said instance will reference either a GlobalDataStore or a DataStore2 instance depending on the arguments given. If `Player` is undefined then it will strictly use legacy Datastores, if `name` is undefined then it will strictly use DataStore2. 

However, if both `name` and `Player` are given, the module will load from legacy DataStore and save to Datastore2 when possible under the `Player` object. 

The `migrationManager` instance will use this data in the functions it returns.





# Instances


# migrationManager

Variant: migrationManager:getAsync(String: Key,...)
  
  returns a value from `Key`. Prefers DataStore2, uses `Player`, `name` and `scope` values from migrationManager instance. 


Variant: migrationManager:SetAsync(String: Key, Variant: Value, ...)
  
  sets `Key` to `Value`, prefers Datastore2.

Variant: migrationManager:RemoveAsync(String: Key,  ...)
  
  Sets the Value of `Key` to a blank string ("") and returns the value it was set as.


  note: This function cannot set values to nil because of problems that arise with DataStore2 when doing so


Variant: migrationManager:IncrementAsync(String: Key, Number: Delta, ...)
  
  adds `Delta` to the existing value under `Key` and returns the changed value.



Variant: migrationManager:UpdateAsync(String: Key, Variant: fun, ...)
  
  This function is functionally the same as GlobalDataStore:UpdateAsync() -

This function will update the value of Key with the new value returned by callback function `fun()`. 

Callback function `fun()` will be called with the value of `Key` as parameters, expecting a returned value to update the key with.
In the event that the save fails (eg: another server is saving to the datastore at the same time,etc), updateAsync will preform a "Reliable Delivery" - this means it will continue to try to
save the data until it is successful. Once it is successful it will return the updated value.

Note-
if `fun` or `Key` is nil then UpdateAsync will return nil and abort  
`fun()` should be treated like a Promise and should not yield








