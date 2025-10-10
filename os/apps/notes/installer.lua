local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/notes/updater.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("notes.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing notes")
    end

    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/notes/uninstaller.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("notes.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing notes")
    end


    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/notes.json")
    if response then
        local code = response.readAll()
        local file = fs.open("notes.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing notes")
    end


    fs.mkdir("/os/storage/notes")