local completion = require("cc.completion")
local db = require("/os/lib/ht-db")

local args = { ... }

if args[1] == "update" then
    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/lib/cli/ht-get.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/lib/cli/ht-get.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while updating ht-get")
    end
end

local res = http.get("http://ht-get.boistou.de")
local data = textutils.unserializeJSON(res.readAll())
res.close()

local function contains (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end



local packages = {}
local uninstalledpackages = {}
local installedpackageslist = {}

local function printPackageInfo(pkg)
    local order = {
        "identifier",
        "type",
        "author",
        "version",
        "description",
        "size"
    }


    print("=== " .. (pkg.displayname or pkg.identifier or "Unnamed Package") .. " ===")

    for _, key in ipairs(order) do
        if pkg[key] ~= nil then
            local value = pkg[key]
            if type(value) == "table" then
                print(key .. ": " .. textutils.serialize(value))
            else
                print(key .. ": " .. tostring(value))
            end
        end
    end

    print()
end


for _, pkg in ipairs(data) do
    if type(pkg) == "table" and pkg.identifier then
        table.insert(packages, pkg.identifier)
    end
end

local function availablePackages()
    local database = db.create("ht-get", "/os/storage/system/ht-get")
    Installedpackages = database:createTable("installedpackages",{
        {name="id", datatype="number", auto_increment=true},
        {name="identifier", datatype="string"},
        {name="type", datatype="string"},
        {name="author", datatype="string"},
        {name="version", datatype="string"},
        {name="installer", datatype="string"},
        {name="updater", datatype="string"},
        {name="uninstaller", datatype="string"},
        {name="versionfile", datatype="string"},
        {name="run", datatype="string"}
    })

    for _, row in ipairs(Installedpackages:getAll()) do
        table.insert(installedpackageslist, row.identifier)
    end

    for _, pkg in ipairs(data) do
        if type(pkg) == "table" and not contains(installedpackageslist, pkg.identifier) then
            table.insert(uninstalledpackages, pkg.identifier)
        end
    end
end

availablePackages()




local function initCompletion()
        local function complete(shell, index, text, previous)
        if index == 1 then
            return completion.choice(text, {"install ", "remove ", "update ", "list", "lookup "})
        elseif index == 2 then
            if previous[2] == "lookup" then
                return completion.choice(text, packages)
            end
            if previous[2] == "install" then
                return completion.choice(text, uninstalledpackages)
            end
            if previous[2] == "remove" or previous[2] == "update" then
                return completion.choice(text, installedpackageslist)
            end
        end
    end

    shell.setCompletionFunction(shell.getRunningProgram(), complete)
end

if args[1] == "list" then
    for _, pkg in ipairs(data) do
        if type(pkg) == "table" and pkg.identifier then
            print(pkg.identifier)
        end
    end
end

if args[1] == "lookup" then
    for _, pkg in ipairs(data) do
        if pkg.identifier == args[2] then
            printPackageInfo(pkg)
            return
        end
    end
    print("No package with name " .. args[2] .. " was found.")
end

if args[1] == "install" then
    for _, pkg in ipairs(data) do
        if pkg.identifier == args[2] and not contains(installedpackageslist, args[2]) then
            Installedpackages:insert({
                identifier = pkg.identifier,
                type = pkg.type,
                author = pkg.author,
                version = pkg.version,
                installer = pkg.installer,
                updater = pkg.updater,
                uninstaller = pkg.uninstaller,
                versionfile = pkg.versionfile,
                run = pkg.run
            })
            shell.run(pkg.installer)
            shell.run(pkg.updater)
            print(args[2] .. " was installed successfully.")
        elseif pkg.identifier == args[2] then
            print(args[2] .. " is already installed.")
        end
    end
end



if args[1] == "remove" then
    for _, pkg in ipairs(Installedpackages:getAll()) do
        if pkg.identifier == args[2] then
            shell.run(pkg.uninstaller)
            Installedpackages:deleteRows(function(r) return r.identifier == pkg.identifier end)
            print(args[2] .. " was uninstalled successfully.")
            return
        end
    end
    print("No package with name " .. args[2] .. " was found.")
    if #Installedpackages:getAll() == 0 then
        print("There are no packages installed to be removed.")
    end
end

if args[1] == "update" then
    for _, pkg in ipairs(Installedpackages:getAll()) do
        if pkg.identifier == args[2] then
            shell.run(pkg.updater)
            print(args[2] .. " was updated successfully.")
            return
        end
    end
    print("No package with name " .. args[2] .. " was found.")
    if #Installedpackages:getAll() == 0 then
        print("There are no packages installed to be updated.")
    end
end


initCompletion()

