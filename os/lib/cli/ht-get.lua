local completion = require("cc.completion")

local args = { ... }

local res = http.get("http://ht-get.boistou.de")
local data = textutils.unserializeJSON(res.readAll())
res.close()

local packages = {}

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
    print("Package '" .. args[2] .. "' was not found.")
end

if args[1] == "install" then
    for _, pkg in ipairs(data) do
        if pkg.identifier == args[2] then
            shell.run(pkg.installer)
            shell.run(pkg.updater)
        end
    end
end



if args[1] == "init" then
    local function complete(shell, index, text, previous)
    if index == 1 then
        return completion.choice(text, {"install ", "remove ", "update ", "list", "lookup "})
    elseif index == 2 then
        if previous[2] == "install" or previous[2] == "lookup" then
            return completion.choice(text, packages)
        end
        
    end
end

shell.setCompletionFunction(shell.getRunningProgram(), complete)
end