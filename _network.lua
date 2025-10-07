-- network.lua
local network = {}
local lastPingTime = os.clock()
local rednetID = os.getComputerID()
local modem = peripheral.find("modem", rednet.open)
-- Zum Debuggen ggf. aktivieren:
-- if not modem then error("No modem found!") end

local deviceName = "unknown"
local deviceType = "unknown"
local towerID = -1
local connected = false
local onReceiveCallback = nil

-- Hilfsfunktion: String an Trennzeichen aufteilen
local function splitString(input, separator)
    local result = {}
    if type(input) ~= "string" or type(separator) ~= "string" then
        return result
    end
    for value in string.gmatch(input, "([^" .. separator .. "]+)") do
        table.insert(result, value)
    end
    return result
end

-- Nachricht an Tower senden
local function sendInternal(targetID, app, param, data)
    if towerID ~= -1 then
        local msg = table.concat({
            tostring(targetID),
            tostring(rednetID),
            deviceName,
            deviceType,
            "D5", "D6", "D7", -- Dummydaten
            tostring(string.gsub(app, ",", "-3ibu4w")), 
            tostring(string.gsub(param, ",", "-3ibu4w")),
            tostring(string.gsub(data, ",", "-3ibu4w"))
        }, ",")
        rednet.send(towerID, msg, "jms_SEND")
    end
end

-- Empfangsschleife
local function receiveLoop()
    while true do
        local id, message, protocol = rednet.receive()
        if protocol == "jms_PING" then
            if towerID == -1 then
                towerID = id
            end
            if id == towerID then
                lastPingTime = os.clock()
                connected = true
                rednet.send(id, deviceName, "jms_JOIN")
            end

        elseif protocol == "jms_FINAL" and onReceiveCallback then
            local msgParts = splitString(message, ",")
            if msgParts[1] and msgParts[7] and msgParts[8] and msgParts[9] then
                local sourceID = tonumber(msgParts[1])
                local app = string.gsub(msgParts[7], "-3ibu4w", ",")
                local param = string.gsub(msgParts[8], "-3ibu4w", ",")
                local data = string.gsub(msgParts[9], "-3ibu4w", ",")
                if param ~= "FORGET" then
                    onReceiveCallback(sourceID,app, param, data)
                end
            end
        end

        

    end
end


local function timeoutLoop()
    while true do
        if towerID == -1 or (os.clock() - lastPingTime > 3) then
            connected = false
            towerID = -1
        end
        sleep(0.5)
    end
end

-- Initialisierung
function network.name(name, dtype)
    deviceName = name or "unknown"
    deviceType = dtype or "unknown"
end



function network.loop()
    parallel.waitForAll(receiveLoop, timeoutLoop)  
end

-- Senden
function network.send(targetID, app, param, data)
    sendInternal(targetID, app, param, data)
end

-- Verbindungsstatus abfragen
function network.isConnected()
    return connected
end

-- Callback setzen für eingehende Nachrichten
function network.onReceive(callback)
    onReceiveCallback = callback
end

return network


-- Add auto connect to tower
-- fix random disconnect