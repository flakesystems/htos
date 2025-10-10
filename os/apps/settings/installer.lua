local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/settings/updater.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("settings.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing settings")
    end

    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/settings/uninstaller.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("settings.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing settings")
    end

        local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/settings.json")
    if response then
        local code = response.readAll()
        local file = fs.open("settings.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing settings")
    end