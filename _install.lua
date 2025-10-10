local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/_install.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/_install.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing notes")
    end

local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/_update.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/_update.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing notes")
    end

local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/lib/ht-db.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/lib/ht-db.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while updating ht-get")
    end

    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/lib/cli/ht-get.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/lib/cli/ht-get.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while updating ht-get")
    end

shell.run("_update")