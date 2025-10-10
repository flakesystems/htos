local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/htmarket/installer.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/apps/htmarket/installer.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing htmarket")
    end

local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/htmarket/updater.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/apps/htmarket/updater.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing htmarket")
    end

    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/htmarket/uninstaller.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/apps/htmarket/uninstaller.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing htmarket")
    end

        local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/htmarket.json")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/apps/htmarket.json", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing htmarket")
    end