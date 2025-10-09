-- test_db.lua
local dbModule = require("/os/lib/ht-db")

--========== Create Database ==========
local myDB = dbModule.create("testdb")
print("Database created")

--========== Create Table ==========
local users = myDB:createTable("users", {
    {name="id", datatype="number", auto_increment=true},
    {name="name", datatype="string"},
    {name="email", datatype="string", default="unknown@example.com"},
})
print("Table 'users' created")

--========== Insert Rows ==========
users:insert({name="Alice"})
users:insert({name="Bob", email="bob@example.com"})
users:insert({name="Charlie"})
print("Rows inserted:")
for _, row in ipairs(users:getAll()) do
    print(textutils.serialize(row))
end

--========== Find Rows ==========
local found = users:find(function(r) return r.name == "Alice" end)
print("Found Alice:")
for _, r in ipairs(found) do
    print(textutils.serialize(r))
end

--========== Update Rows ==========
local updated = users:updateRows(
    function(r) return r.name == "Bob" end,
    function(r) r.email = "bob123@example.com" end
)
print("Updated rows count:", updated)
for _, row in ipairs(users:getAll()) do
    print(textutils.serialize(row))
end

--========== Delete Rows ==========
local deleted = users:deleteRows(function(r) return r.name == "Charlie" end)
print("Deleted rows count:", deleted)
for _, row in ipairs(users:getAll()) do
    print(textutils.serialize(row))
end

--========== Add Column ==========
users:addColumn({name="age", datatype="number", default=18})
print("Added column 'age':")
for _, row in ipairs(users:getAll()) do
    print(textutils.serialize(row))
end

--========== Update Column ==========
users:updateColumn("age", {default=21})
print("Updated column 'age' default to 21")
users:insert({name="David"})
for _, row in ipairs(users:getAll()) do
    print(textutils.serialize(row))
end

--========== Delete Column ==========
users:deleteColumn("email")
print("Deleted column 'email'")
for _, row in ipairs(users:getAll()) do
    print(textutils.serialize(row))
end

--========== Save and Reload DB ==========
myDB:save()
print("Database saved")

local loadedDB, success = dbModule.create("testdb")
if not success == false then
    loadedDB:load()
    print("Database loaded")
    local loadedUsers = loadedDB:getTable("users")
    for _, row in ipairs(loadedUsers:getAll()) do
        print("Loaded row:", textutils.serialize(row))
    end
end
--========== Delete Table ==========
myDB:deleteTable("users")
print("Table 'users' deleted")

--========== Delete Database ==========
myDB:delete()
print("Database deleted")
