local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/_update.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/_update.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing system updater")
    end

-- Basalt installieren
local function installBasalt()
    shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt/refs/heads/master/docs/install.lua release basalt-1.7.0.lua")

-- Wait until Basalt is downloaded and installed
    print("Waiting for Basalt to be downloaded...")
    sleep(1)  -- Wait for a second before checking again
if fs.exists("basalt.lua") then
    fs.move("basalt.lua","_basalt.lua")
end
end

local function install()
    
    local networkfileCode = "ZLcJcYtq"
    local networkfileName = "_network.lua"

    shell.run("pastebin get " .. networkfileCode .. " " .. networkfileName)

    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/startup.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/startup.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing startup")
    end

    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/main.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/main.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing main")
    end

    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/fastreboot.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/fastreboot.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing fastreboot")
    end

    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/_visualiser.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/_visualiser.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing visualiser")
    end

    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/_log.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/_log.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing logger")
    end

    local response = http.get("https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/_handler.lua")
    if response then
        local code = response.readAll()
        local file = fs.open("/_handler.lua", "w")
        file.write(code)
        file.close()
    else
        print("Error while installing handler")
    end

    shell.setDir("/os/lib/cli")
    shell.run("ht-get install logdisplay")
    shell.run("ht-get install vault")
    shell.run("ht-get install networking")
    shell.run("ht-get install ht-ctl")
    shell.run("ht-get install calc")
    shell.run("ht-get install htmarket")
    shell.run("ht-get install notes")
    shell.run("ht-get install settings")
    shell.run("ht-get install shell")
    shell.setDir("/")
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


-- Hauptprogramm
local function main()
    print("[*] Installiere Basalt...")
    installBasalt()
    print("[*] Dateisystem bauen...")
    buildFileSystem()
    install()
    shell.run("startup")
end

-- Programm starten
main()