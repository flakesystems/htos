local db = {}
db.__index = db

local dbtable = {}
dbtable.__index = dbtable

--========== Dummy DB for safety ==========--
local function dummyDB(err)
    local t = {}
    setmetatable(t, {
        __index = function(_, key)
            return function()
                print("Error (dummy DB):", err)
                return nil
            end
        end
    })
    return t
end

--========== Dummy table for safety ==========--
local function dummyTable(err)
    local t = {}
    setmetatable(t, {
        __index = function(_, key)
            return function()
                print("Error (dummy table):", err)
            end
        end
    })
    return t
end

--========== Database creation ==========--
function db.create(name, path, overwrite)
    -- argument handling
    if type(path) == "boolean" and overwrite == nil then
        overwrite = path
        path = "/os/storage/db"
    else
        path = path or "/os/storage/db"
    end

    if string.sub(path, -1) ~= "/" then
        path = path .. "/"
    end

    local fullPath = path .. name .. ".db"

    -- If database already exists, load it instead of overwriting
    if fs.exists(fullPath) and not overwrite then
        local self = {
            name = name,
            path = fullPath,
            tables = {}
        }
        setmetatable(self, db)
        self:load()  -- Load the existing data
        return self
    end

    -- If overwrite is explicitly true, recreate the file
    if fs.exists(fullPath) and overwrite then
        fs.delete(fullPath)
    end

    -- Create a new file if it doesn't exist
    if not fs.exists(fullPath) then
        local f = fs.open(fullPath, "w")
        if not f then
            print("Error: failed to create file", fullPath)
            return dummyDB("failed to create file")
        end
        f.write(textutils.serialize({tables = {}}))
        f.close()
    end

    local self = {
        name = name,
        path = fullPath,
        tables = {}
    }

    return setmetatable(self, db)
end


--========== Load DB from file ==========--
function db:load()
    if not self or not self.path then
        print("Error: invalid database object")
        return false
    end

    if not fs.exists(self.path) then
        print("Error: file not found", self.path)
        return false
    end

    local f = fs.open(self.path, "r")
    local data = textutils.unserialize(f.readAll())
    f.close()

    if data and data.tables then
        for name, t in pairs(data.tables) do
            local tableObj = setmetatable({
                name = name,
                columns = t.columns,
                rows = t.rows or {},
                auto_increment_counters = t.auto_increment_counters or {},
                parent = self
            }, dbtable)
            self.tables[name] = tableObj
        end
    end

    return true
end

--========== Save DB ==========--
function db:save()
    if not self or not self.path then
        print("Error: invalid database object")
        return false
    end

    local out = {tables = {}}
    for name, t in pairs(self.tables) do
        if t and t.columns and t.rows then
            out.tables[name] = {
                columns = t.columns,
                rows = t.rows,
                auto_increment_counters = t.auto_increment_counters
            }
        end
    end

    local f = fs.open(self.path, "w")
    if not f then
        print("Error: failed to open file for writing", self.path)
        return false
    end
    f.write(textutils.serialize(out))
    f.close()
    return true
end

--========== Delete the database file ==========--
function db:delete()
    if self.path and fs.exists(self.path) then
        fs.delete(self.path)
        self.tables = {}
        print("Database deleted:", self.path)
        return true
    end
    print("Error: database file does not exist")
    return false
end

--========== Create a new table ==========--
function db:createTable(name, columns, doexistcheck)
    if not self then
        return dummyTable("invalid database object")
    end

    if self.tables[name] and doexistcheck == true then
        print("Warning: table already exists:", name)
        return dummyTable("table already exists")
    elseif self.tables[name] then
        return self.tables[name]
    end

    local t = setmetatable({
        name = name,
        columns = columns or {},
        rows = {},
        auto_increment_counters = {},
        parent = self
    }, dbtable)

    -- initialize auto_increment counters
    for _, col in ipairs(columns) do
        if col.auto_increment then
            t.auto_increment_counters[col.name] = 0
        end
    end

    self.tables[name] = t
    self:save()
    return t
end

--========== Delete a table ==========
function db:deleteTable(name)
    if self.tables[name] then
        self.tables[name] = nil
        self:save()
        return true
    end
    print("Error: table does not exist:", name)
    return false
end

--========== Get a table by name ==========
function db:getTable(name)
    if not self or not self.tables then
        print("Error: invalid database object")
        return dummyTable("invalid database object")
    end

    return self.tables[name] or dummyTable("table does not exist: " .. name)
end

--========== Table methods ==========
function dbtable:insert(row)
    if not self or not self.columns or not self.rows or not self.parent then
        print("Error: invalid table object")
        return false
    end

    local newRow = {}
    for _, col in ipairs(self.columns) do
        local val = row[col.name]

        -- handle auto_increment
        if col.auto_increment then
            if val == nil then
                self.auto_increment_counters[col.name] = (self.auto_increment_counters[col.name] or 0) + 1
                val = self.auto_increment_counters[col.name]
            else
                self.auto_increment_counters[col.name] = math.max(self.auto_increment_counters[col.name] or 0, val)
            end
        end

        -- handle default
        if val == nil and col.default ~= nil then
            val = type(col.default) == "function" and col.default() or col.default
        end

        -- type check
        if val ~= nil and col.datatype then
            if col.datatype == "number" and type(val) ~= "number" then
                print("Error: column", col.name, "expects number, got", type(val))
                return false
            elseif col.datatype == "string" and type(val) ~= "string" then
                print("Error: column", col.name, "expects string, got", type(val))
                return false
            end
        end

        newRow[col.name] = val
    end

    table.insert(self.rows, newRow)
    self.parent:save()
    return true
end

function dbtable:getAll()
    if not self or not self.rows then
        print("Error: invalid table object")
        return dummyTable("invalid table object")
    end
    return self.rows
end

function dbtable:find(filterFn)
    if not self or not self.rows then
        print("Error: invalid table object")
        return dummyTable("invalid table object")
    end

    local result = {}
    for _, row in ipairs(self.rows) do
        if filterFn(row) then
            table.insert(result, row)
        end
    end
    return result
end

--========== Delete rows by filter function ==========
function dbtable:deleteRows(filterFn)
    if not self or not self.rows then
        print("Error: invalid table object")
        return false
    end

    local newRows = {}
    local count = 0
    for _, row in ipairs(self.rows) do
        if filterFn(row) then
            count = count + 1
        else
            table.insert(newRows, row)
        end
    end
    self.rows = newRows
    self.parent:save()
    return count
end

--========== Update rows by filter function ==========
function dbtable:updateRows(filterFn, updateFn)
    if not self or not self.rows then
        print("Error: invalid table object")
        return 0
    end

    local count = 0
    for _, row in ipairs(self.rows) do
        if filterFn(row) then
            updateFn(row)
            count = count + 1
        end
    end
    if count > 0 then self.parent:save() end
    return count
end

--========== Column operations ==========
function dbtable:addColumn(colAttributes)
    if not colAttributes or not colAttributes.name then
        print("Error: invalid column attributes")
        return false
    end

    for _, col in ipairs(self.columns) do
        if col.name == colAttributes.name then
            print("Error: column already exists:", colAttributes.name)
            return false
        end
    end

    table.insert(self.columns, colAttributes)

    if colAttributes.auto_increment then
        self.auto_increment_counters[colAttributes.name] = 0
    end

    for _, row in ipairs(self.rows) do
        if colAttributes.auto_increment then
            self.auto_increment_counters[colAttributes.name] = self.auto_increment_counters[colAttributes.name] + 1
            row[colAttributes.name] = self.auto_increment_counters[colAttributes.name]
        elseif colAttributes.default ~= nil then
            row[colAttributes.name] = type(colAttributes.default) == "function" and colAttributes.default() or colAttributes.default
        else
            row[colAttributes.name] = nil
        end
    end

    self.parent:save()
    return true
end

function dbtable:deleteColumn(columnName)
    local idx
    for i, col in ipairs(self.columns) do
        if col.name == columnName then idx = i end
    end
    if not idx then
        print("Error: column not found", columnName)
        return false
    end

    table.remove(self.columns, idx)
    self.auto_increment_counters[columnName] = nil

    for _, row in ipairs(self.rows) do
        row[columnName] = nil
    end

    self.parent:save()
    return true
end

function dbtable:updateColumn(columnName, newAttributes)
    for _, col in ipairs(self.columns) do
        if col.name == columnName then
            for k,v in pairs(newAttributes) do
                col[k] = v
            end
            self.parent:save()
            return true
        end
    end
    print("Error: column not found", columnName)
    return false
end

return db
