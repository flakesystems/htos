local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/calc/installer.lua")
if response then
    local code = response.readAll()
    if fs.exists("/os/apps/calc/installer.lua") then
        fs.delete("/os/apps/calc/installer.lua")
    end
    local file = fs.open("/os/apps/calc/installer.lua", "w")
    file.write(code)
    file.close()
else
    print("Error while installing calc")
end

local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/calc/updater.lua")
if response then
    local code = response.readAll()
    if fs.exists("/os/apps/calc/updater.lua") then
        fs.delete("/os/apps/calc/updater.lua")
    end
    local file = fs.open("/os/apps/calc/updater.lua", "w")
    file.write(code)
    file.close()
else
    print("Error while installing calc")
end

local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/calc/uninstaller.lua")
if response then
    local code = response.readAll()
    if fs.exists("/os/apps/calc/uninstaller.lua") then
        fs.delete("/os/apps/calc/uninstaller.lua")
    end
    local file = fs.open("/os/apps/calc/uninstaller.lua", "w")
    file.write(code)
    file.close()
else
    print("Error while installing calc")
end

local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/calc.json")
if response then
    if fs.exists("/os/apps/calc.json") then
        fs.delete("/os/apps/calc.json")
    end
    local code = response.readAll()
    local file = fs.open("/os/apps/calc.json", "w")
    file.write(code)
    file.close()
else
    print("Error while installing calc")
end
