-- startup
-- This script runs on computer startup to initialize logging

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