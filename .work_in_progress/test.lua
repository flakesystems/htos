require("/log")
local acc = {}

function acc.login(username, password)
    print("Username:", username)
    print("Password:", password)

    local jsonBody = textutils.serialiseJSON({identity = username, password = password})
    local request = http.post("https://mls-technik.de/", jsonBody)
    local json = textutils.unserialiseJSON(request.readAll()).response

    local error = json.message

    local record = json.record

    if error then
        Log(error, "ERROR")
        local user = false
    else

        local user = {}
        for k, v in pairs(record) do
            user[k] = v
        end
    end
    request.close()
end

return acc
