-- Name der herunterzuladenden Datei
local pastebinCode = "bi6C2PcM"
local fileName = "update.lua"

-- Funktion zum Herunterladen und Überschreiben der Datei
local function downloadFile()
    if fs.exists(fileName) then
        fs.delete(fileName) -- Lösche die Datei, falls sie bereits existiert
    end
    shell.run("pastebin get " .. pastebinCode .. " " .. fileName)
end



-- Hauptprogramm
local function main()
    print("[*] Updaten von " .. fileName .. "...")
    downloadFile()
    print("[*] Ausführen von " .. fileName .. "...")
    shell.run(fileName)
end

-- Programm starten
main()