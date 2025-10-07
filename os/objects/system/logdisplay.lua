local showtimecode = 0

-- Define tag-to-color mappings
local tagColors = {
    ["[ERROR]"] = colors.red,
    ["[DEV]"] = colors.purple,
    ["[INFO]"] = colors.blue, -- Example: Add more tags here
    ["[WARN]"] = colors.yellow
}

function ColorizeAndPrint(line)
    local prefix, rest = line:match("(%[.-%])(.+)") -- Extract tag and rest of the line

    if prefix then
        local color = tagColors[prefix] or colors.white -- Default to white if not in table

        term.setTextColor(color)
        write(prefix) -- Print only the tag in color
        term.setTextColor(colors.white) -- Reset color
        print(rest) -- Print the rest of the line normally
    else
        print(line) -- Print normal lines without modification
    end
end

function Checklogs()
    if fs.exists("/os/logs/latest.log") then
        for line in io.lines("/os/logs/latest.log") do
            if showtimecode == 0 then
                line = line:gsub("%[%d+%]%s*", "") -- Remove timestamps
            end
            ColorizeAndPrint(line)
        end
    end
end

shell.run("clear")
Checklogs()

while true do
    local id, message = os.pullEvent("log_update")
    showtimecode = message
    shell.run("clear")
    Checklogs()
end
