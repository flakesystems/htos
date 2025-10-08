fs.delete('/startup.lua')
fs.move('/tempstartup.lua','/startup.lua')

local path = shell.path()
local myFolder = "/os/lib/cli"

-- check if already in path
if not path:find(myFolder, 1, true) then
    shell.setPath(path .. ":" .. myFolder)
end

shell.run("ht-get init")
shell.run("ht-ctl init")


shell.run('/main.lua')