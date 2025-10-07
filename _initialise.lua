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


--Start log mechanic

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