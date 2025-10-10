local args = { ... }

if args[1] == "update" then
    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/lib/networking.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/lib/networking.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while updating ht-get")
    end
end