local completion = require("cc.completion")
local handler = require("/_handler")

local args = { ... }

if args[1] == "update" then
    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/lib/cli/ht-ctl.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/os/lib/cli/ht-ctl.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while updating ht-ctl")
    end
end

if args[1] == "system" and args[2] == "reload" then
    handler.fastreboot()
end

if args[1] == "system" and args[2] == "reboot" then
    os.reboot()
end

if args[1] == "system" and args[2] == "shutdown" then
    os.shutdown()
end

if args[1] == "start" or args[1] == "stop" or args[1] == "status" then
    print("Process handling is still work in progress.")
end

if args[1] == "init" then
    local function complete(shell, index, text, previous)
    if index == 1 then
        return completion.choice(text, {"start ", "stop ", "status ", "system ", "info"})
    elseif index == 2 then
        if previous[2] == "system" then
            return completion.choice(text, {"reload", "reboot", "shutdown"})
        end
        
    end
end

shell.setCompletionFunction(shell.getRunningProgram(), complete)
end