local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/shell/updater.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/apps/shell/updater.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installer shell")
    end

    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/shell/uninstaller.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/apps/shell/uninstaller.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installer shell")
    end

        local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/shell.json")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/apps/shell.json", "w")
        file.write(code)
        file.close()
    else
        print("Error while installer shell")
    end