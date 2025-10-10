local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/calc/updater.lua")
if response then
    local code = response.readAll()
    local file = fs.open("calc.lua", "w")
    file.write(code)
    file.close()
else
    print("Error while installing calc")
end

local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/calc/uninstaller.lua")
if response then
    local code = response.readAll()
    local file = fs.open("calc.lua", "w")
    file.write(code)
    file.close()
else
    print("Error while installing calc")
end

local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/calc.json")
if response then
    local code = response.readAll()
    local file = fs.open("calc.lua", "w")
    file.write(code)
    file.close()
else
    print("Error while installing calc")
end