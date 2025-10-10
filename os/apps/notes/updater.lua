local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/notes/notes.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/apps/notes/notes.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while updating notes")
    end