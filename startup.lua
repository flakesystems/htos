-- startup
local db = require("/os/lib/ht-db")

-- Define the base directory for logs
local logBaseDir = "/os/logs/"
local logArchiveDir = "/os/logs/archive/"

-- Ensure the log directory exists
if not fs.exists(logBaseDir) then
    fs.makeDir(logBaseDir)
end

-- Ensure the archive directory exists
if not fs.exists(logArchiveDir) then
    fs.makeDir(logArchiveDir)
end

if fs.exists(logBaseDir .. "latest.log") then
    fs.move(logBaseDir .. "latest.log", logArchiveDir .. os.epoch("utc") .. ".log.gz")
end

local path = shell.path()
local myFolder = "/os/lib/cli"

-- check if already in path
if not path:find(myFolder, 1, true) then
    shell.setPath(path .. ":" .. myFolder)
end

shell.run("ht-get init")
shell.run("ht-ctl init")

--convert legacy librarys/apps into packages
local database = db.create("ht-get", "/os/storage/system/ht-get")
Installedpackages = database:getTable("installedpackages")

for _, file in ipairs(fs.list("/os/apps")) do

    if file:match("%.json$") then
        local path = "/os/apps/" .. file
        local f = fs.open(path, "r")

        if f then
            local ok, data = pcall(function()
                return textutils.unserializeJSON(f.readAll())
            end)
            f.close()

            if ok and type(data) == "table" and data.identifier and data.displayname and data.run then
                local found = Installedpackages:find(function(r) return r.identifier == data.identifier end)
                if textutils.serialise(found) == "{}" then
                    Installedpackages:insert({
                        identifier = data.identifier,
                        type = "app",
                        author = data.author or "Unknown",
                        version = data.version or "1.0",
                        installer = data.installer or nil,
                        updater = data.updater or nil,
                        uninstaller = data.uninstaller or nil,
                        versionfile = data.versionfile or nil,
                        run = data.run
                    })
                    print("registered package " .. data.identifier)
                end
            else
                print("Invalid or missing fields in:", file)
            end
        else
            print("Failed to open:", file)
        end
    end
end

for _, file in ipairs(fs.list("/os/lib")) do

    if file:match("%.lua$") then
        local path = "/os/lib/" .. file
        local found = Installedpackages:find(function(r) return r.identifier == string.gsub(file,".lua","") end)
                if textutils.serialise(found) == "{}" then
                    Installedpackages:insert({
                        identifier = string.gsub(file,".lua",""),
                        type = "library",
                        uninstaller = "delete " .. path
                    })
                    print("registered package " .. string.gsub(file,".lua",""))
                end
    end
end

for _, file in ipairs(fs.list("/os/lib/cli")) do

    if file:match("%.lua$") then
        local path = "/os/lib/cli/" .. file
        local found = Installedpackages:find(function(r) return r.identifier == string.gsub(file,".lua","") end)
                if textutils.serialise(found) == "{}" then
                    Installedpackages:insert({
                        identifier = string.gsub(file,".lua",""),
                        type = "cli",
                        uninstaller = "delete " .. path
                    })
                    print("registered package " .. string.gsub(file,".lua",""))
                end
    end
end

local versionfile = fs.open("version.txt", "r")
local version = versionfile.readAll()
versionfile.close()
local versionlink = "m5CDWzU7"


--Define Config

settings.define("general.timeFormat", {
  description = "Set Clock Type",
  default = 2,
  type = "number",
})
settings.define("general.Label", {
  description = "Set Computer Label",
  default = "htos" .. os.getComputerID(),
  type = "string",
})
settings.define("dev.enabled", {
  description = "Enable Developer Mode",
  default = false,
  type = "boolean",
})
settings.save(".settings")


 --Check for updates

local function checkforupdate()
    if fs.exists("version.txt") then
        fs.delete("version.txt") -- Lösche die Datei, falls sie bereits existiert
    end
    print("[*] Getting Version File...")
    shell.run("pastebin get " .. versionlink .. " version.txt")
      local newversionfile = fs.open("version.txt", "r")
      local newversion = newversionfile.readAll()
      newversionfile.close()
      print("[*] Current Version: " .. version)
      sleep(1)
      print("[*] Newest Version: " .. newversion)
    if (newversion ~= version) then
      sleep(1)
      if fs.exists("update.lua") then
        fs.delete("update.lua") -- Lösche die Datei, falls sie bereits existiert
      end
      shell.run("pastebin get " .. "bi6C2PcM" .. " " .. "update.lua")
      print("[*] Updating...")
      --shell.run("_update.lua")
    end
end

local function main()
    checkforupdate()
    sleep(1)
    shell.run("main.lua")
    shell.exit()
end

main()