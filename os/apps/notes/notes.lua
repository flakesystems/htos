require("/_log")

local running = true

-- Listen for messages as events (ideal for Program:injectEvent())
while running do
    local event, senderID, message = os.pullEvent("app_message")
    local messageTable = textutils.unserialise(message)
    -- Only handle messages from Program:injectEvent
    if type(senderID) == "number" and type(message) == "string" then
        Log(("Computer %d sent message: %s"):format(senderID, messageTable.param .. " -> " .. messageTable.data), "DEV")
    end
end