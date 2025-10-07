-- Name der herunterzuladenden Datei
local pastebinCode = "BVxAM3XS"
local fileName = "main.lua"
local htosAppCalcCode = "nJ17qcHy"
local htosAppCalcName = "calc.lua"
local htosAppNotesCode = "4XGitJnf"
local htosAppNotesName = "notes.lua"
local htosAppShellCode = "pFcXF84V"
local htosAppShellName = "shell.lua"
local htosAppSettingsCode = "mkxBqrig"
local htosAppSettingsName = "settings.lua"
local versionlink = "m5CDWzU7"
local initialisefileCode = "Jys8jH1g"
local initialisefileName = "initialise.lua"
local logfileCode = "FbEpBfCG"
local logfileName = "log.lua"
local networkfileCode = "ZLcJcYtq"
local networkfileName = "network.lua"
local logobjectfileCode = "8waeN33W"
local logobjectfileName = "logdisplay.lua"
local vaultlibfileCode = "GmXbTYpE"
local vaultlibfileName = "vault.lua"

-- Funktion zum Herunterladen und Überschreiben der Datei
local function downloadFile()
    if fs.exists(fileName) then
        fs.delete(fileName) -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. pastebinCode .. " " .. fileName)
end

-- Basalt installieren
local function installBasalt()
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt/refs/heads/master/docs/install.lua release basalt-1.7.0.lua")

-- Wait until Basalt is downloaded and installed
while not fs.exists("basalt.lua") do
    print("Waiting for Basalt to be downloaded...")
    sleep(1)  -- Wait for a second before checking again
end
end

-- Dateisystem bauen
local function buildFileSystem()
    if not fs.exists("os") then
        fs.makeDir("os")
    end
    if not fs.exists("os/apps") then
        fs.makeDir("os/apps")
    end
    if not fs.exists("os/objects") then
        fs.makeDir("os/objects")
    end
    if not fs.exists("os/lib") then
        fs.makeDir("os/lib")
    end
    if not fs.exists("os/logs") then
        fs.makeDir("os/logs")
    end
    if not fs.exists("os/storage") then
        fs.makeDir("os/storage")
    end
    if not fs.exists("os/vault") then
        fs.makeDir("os/vault")
    end
end
-- Calc App installieren
local function downloadCalc()
    if fs.exists("os/apps/" .. htosAppCalcName) then
        fs.delete("os/apps/" .. htosAppCalcName) -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. htosAppCalcCode .. " os/apps/" .. htosAppCalcName)
end

-- Notes App installieren
local function downloadNotes()
    if fs.exists("os/apps/" .. htosAppNotesName) then
        fs.delete("os/apps/" .. htosAppNotesName) -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. htosAppNotesCode .. " os/apps/" .. htosAppNotesName)
end

-- Shell App installieren
local function downloadShell()
    if fs.exists("os/apps/" .. htosAppShellName) then
        fs.delete("os/apps/" .. htosAppShellName) -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. htosAppShellCode .. " os/apps/" .. htosAppShellName)
end

-- Shell App installieren
local function downloadSettings()
    if fs.exists("os/apps/" .. htosAppSettingsName) then
        fs.delete("os/apps/" .. htosAppSettingsName) -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. htosAppSettingsCode .. " os/apps/" .. htosAppSettingsName)
end

-- Funktion, um das Skript in den Autostart-Ordner einzufügen
local function setupAutostart()
    local autostartPath = "startup/" .. fs.getName(initialisefileName)
    if not fs.exists("startup") then
        fs.makeDir("startup")
    end
	if fs.exists(autostartPath) then
		fs.delete(autostartPath)
	end
    if not fs.exists(autostartPath) then
        fs.copy(initialisefileName, autostartPath)
    end
end

local function getversionfile()
    if fs.exists("version.txt") then
        fs.delete("version.txt") -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. versionlink .. " version.txt")
end

local function downloadInitialise()
    if fs.exists(initialisefileName) then
        fs.delete(initialisefileName) -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. initialisefileCode .. " " .. initialisefileName)
end

local function downloadLog()
    if fs.exists(logfileName) then
        fs.delete(logfileName) -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. logfileCode .. " " .. logfileName)
end

local function downloadNetwork()
    if fs.exists(networkfileName) then
        fs.delete(networkfileName) -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. networkfileCode .. " " .. networkfileName)
end

local function downloadLogObject()
    if fs.exists("os/objects/system/" .. logobjectfileName) then
        fs.delete("os/objects/system/" .. logobjectfileName) -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. logobjectfileCode .. " os/objects/system/" .. logobjectfileName)
end

local function downloadLib()
    if fs.exists("os/lib/" .. vaultlibfileName) then
        fs.delete("os/lib/" .. vaultlibfileName) -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. vaultlibfileCode .. " os/lib/" .. vaultlibfileName)
end

-- Hauptprogramm
local function main()
    print("[*] Installiere Basalt...")
    installBasalt()
    print("[*] Versionsdatei herunterladen...")
    getversionfile()
    print("[*] Dateisystem bauen...")
    buildFileSystem()
    print("[*] Systemapp Calc installieren...")
    downloadCalc()
    print("[*] Systemapp Notes installieren...")
    downloadNotes()
    print("[*] Systemapp Shell installieren...")
    downloadShell()
    print("[*] Systemapp Settings installieren...")
    downloadSettings()
    print("[*] Systemapp Settings installieren... -> Benötigte Objekte installieren")
    downloadLogObject()
    print("[*] Logging Paket installieren...")
    downloadLog()
    print("[*] Networking Paket installieren...")
    downloadNetwork()
    print("[*] Bibliotheken installieren...")
    downloadLib()
    print("[*] Updaten von " .. fileName .. "...")
    downloadFile()
    print("[*] Initialisierungsscript installieren...")
    downloadInitialise()
    print("[*] Einfügen in den Autostart...")
    setupAutostart()
    print("[*] Ausführen von " .. initialisefileName .. "...")
    shell.run("startup/" .. initialisefileName)
end

-- Programm starten
main()