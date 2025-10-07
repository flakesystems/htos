-- Define the base directory for logs
local logBaseDir = "/os/logs/"
local logArchiveDir = "/os/logs/archive"

function Log(message,type)
    -- Ensure the log directory exists
    if not fs.exists(logBaseDir) then
        fs.makeDir(logBaseDir)
    end

    -- Ensure the archive directory exists
    if not fs.exists(logArchiveDir) then
        fs.makeDir(logArchiveDir)
    end

    if not fs.exists(logBaseDir .. "latest.log") then
       local new = fs.open(logBaseDir .. "latest.log", "w")
        new.close()
    end

    local latest = fs.open(logBaseDir .. "latest.log", "a")
    latest.writeLine("[" .. type .. "] " .. "[" .. os.epoch("utc") .. "] " .. message)
    latest.close()
end