require("/_visualiser")
local handler = {}

function handler.fastreboot()
    fs.move("/startup.lua","/tempstartup.lua")
    local file =fs.open("/fastreboot.lua", "r")
    local script = file.readAll()
    file.close()
    local file = fs.open("/startup.lua","w")
    file.write(script)
    file.close()
    os.reboot()
end

function handler.popup(color, label, btn1, btn2)
    os.queueEvent("popup_event", color, label, btn1, btn2)
    
    while true do
        local event, id = os.pullEvent("popup_return_event")
        if id == 0 then
            return
        else
            return id
        end
    end
end

function handler.checkperms()
    local perminfo = debug.getinfo(2, "S")
    local perm = string.gsub(perminfo.source,".lua","")
    local appinfo = debug.getinfo(3, "S")
    local name = string.gsub(string.gsub(appinfo.source,"/os/apps/", ""),"/[^/]+%.lua$", "")
    if settings.get("perms." .. perm .. "." .. appinfo.source) == true then
        return true
    elseif handler.popup(colors.orange,"Do you want to grant " .. NewApp[ResolveAppName(name)].name .. " the permission \"" .. perm .. "\"?", "Yes", "No") == 1 then
        settings.set("perms." .. perm .. "." .. appinfo.source, true)
        settings.save("/.settings")
        return true
    else
        return false
    end
end

return handler