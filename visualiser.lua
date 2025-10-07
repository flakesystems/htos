function Visualiser()
    -- Import dependencies
    require("/log")
    local network = require("/network")
    local basalt = require("/basalt")

    -- Create main UI frame with theme
    local main = basalt.addFrame():setTheme({
        FrameBG = colors.lightGray,
        FrameFG = colors.black
    })

    -- App metadata table
    local newApp = {}
    newApp[0] = {
        name = "unexpected error",
        path = "nil",
        index = 0,
        sub = 0,
    }

    -- Initialize UI subframes and other tables
    local i = 1
    local sub = {
        main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 2"),
    }
    local programs = {}
    local messageQueues = {}

    -- Scan /os/apps directory and register each .lua file as an app
    for _, file in ipairs(fs.list("/os/apps")) do
        table.insert(sub, main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 2"):hide())
        local app = string.gsub(file,".lua","")
        table.insert(newApp, {
            name = app,
            path = file,
            index = i,
            sub = 0,
        })
        messageQueues[app] = {}
        i = i + 1
    end

    -- Helper to switch visible subframe
    local function openSubFrame(id)
        if sub[id] ~= nil then
            for _, v in pairs(sub) do v:hide() end
            sub[id]:show()
        end
    end

    --Create Top Bar
    local topbar = main:addFrame()
        :setSize("parent.w", 1)
        :setPosition(1, 1)
        :setBackground(colors.gray)

    -- Create top menu bar with "Home" as default tab
    local menubar = topbar:addMenubar()
        :setScrollable()
        :setSize("parent.w -2")
        :onChange(function(self, val)
            openSubFrame(self:getItemIndex())
        end)
        :addItem("Home")

    --Add Notification Center
    local notificationcenter = topbar:addButton()
        :setSize(3,1)
        :setPosition("parent.w - 2", 1)
        :setText("0")
        :setBackground(colors.blue)


    local function UpdateNotificationcenter()
        os.sleep(2)
        local totalMessages = 0
        local totalMessagesString = ""
        for _, queue in pairs(messageQueues) do
            totalMessages = totalMessages + #queue
        end
        if totalMessages > 9 then
            totalMessagesString = "+"
        else
            totalMessagesString = "" .. totalMessages
        end
        notificationcenter:setText(totalMessagesString):setBackground(colors.blue)
    end

    local function ResetNotificationcenter()
        local totalMessages = 0
        local totalMessagesString = ""
        for _, queue in pairs(messageQueues) do
            totalMessages = totalMessages + #queue
        end
        if totalMessages > 9 then
            totalMessagesString = "+"
        else
            totalMessagesString = "" .. totalMessages
        end
        notificationcenter:setText(totalMessagesString):setBackground(colors.blue)
    end

    local notificationThread = main:addThread()

    local function onNotification()
        notificationcenter:setText("!"):setBackground(colors.red)
        notificationThread:start(UpdateNotificationcenter)
    end

    -- Create main app launch panel on "Home" tab
    local flex = sub[1]:addFlexbox()
        :setWrap("wrap")
        :setBackground(colors.lightGray)
        :setPosition(2, 2)
        :setSize("parent.w", "parent.h - 1")

    -- Helper to find app index by name
    function CheckAppName(name)
        for _, app in ipairs(newApp) do
            if app.name == name then return app.index end
        end
        return nil
    end

    -- Queue message if app is not ready
    local function QueueMessage(msg)
        if msg.dest and messageQueues[msg.dest] then
            table.insert(messageQueues[msg.dest], msg)
            Log("Queued message for "..msg.dest, "INFO")
            AppButton[ResolveAppName(msg.dest)]:setBackground(colors.red)
            onNotification()
        end
    end

    -- Validate and route incoming messages
    function Checkmessage(rmessage)
        if type(rmessage.sender) ~= "number" then
            Log("Received message from wrong formatted sender:" .. tostring(rmessage.sender), "ERROR")
        elseif type(rmessage.dest) ~= "string" then
            Log("Received message to wrong formatted destination:" .. tostring(rmessage.dest), "ERROR")
        elseif type(rmessage.param) ~= "string" then
            Log("Received message with wrong formatted param:" .. tostring(rmessage.param), "ERROR")
        elseif type(rmessage.data) == "nil" then
            Log("Received message with nil data", "ERROR")
        elseif type(CheckAppName(rmessage.dest)) == "nil" then
            Log("Received message for unresolvable appname:" .. rmessage.dest, "WARNING")
        else
            if programs[rmessage.dest] then
                programs[rmessage.dest]:injectEvent("app_message", false, rmessage.sender, textutils.serialise({param = rmessage.param, data = rmessage.data}))
            else
                QueueMessage(rmessage)
            end
        end
    end

    -- Handle incoming messages from network
    network.onReceive(function(senderID, app, param, data)
        Log("Got message with values: sender = " .. senderID .. " target = " .. app .. " param = " .. param .. " data = " .. data, "DEV")
        local rmessage = {
            sender = senderID,
            dest = app,
            param = param,
            data = data
        }
        Checkmessage(rmessage)
    end)

    -- Store all app launcher buttons
    AppButton = {}

    -- Helper to resolve app name to its index
    function ResolveAppName(name)
        for i, app in ipairs(newApp) do
            if app.name == name then return app.index end
        end
    end

    -- Add launcher buttons for each app
    for _, appData in ipairs(newApp) do
        table.insert(AppButton, flex:addButton()
            :setText(appData.name)
            :setSize(10,3)
            :onClick(function(self,event,button,x,y)
                if (event=="mouse_click") and (button==1) then
                    local wdh = menubar:getItemCount()
                    local menusuc = 0

                    -- Check if already in menu
                    for l = wdh,1,-1 do
                        if menubar:getItem(l).text == appData.name then
                            menusuc = 1
                            openSubFrame(l)
                            menubar:selectItem(l)
                            break
                        end
                    end

                    -- If not, add to menu
                    if menusuc == 0 then
                        menubar:addItem(appData.name)
                        openSubFrame(wdh + 1)
                        menubar:selectItem(wdh + 1)
                        newApp[appData.index].sub = wdh + 1

                        -- Execute the app in the subframe
                        programs[appData.name] = sub[newApp[appData.index].sub]:addProgram()
                            :execute("os/apps/" .. appData.path)
                            :setSize("parent.w","parent.h")

                        -- Process queued messages
                        for _, queued in ipairs(messageQueues[appData.name]) do
                            programs[appData.name]:injectEvent("app_message", false, queued.sender, textutils.serialise({param = queued.param, data = queued.data}))
                        end
                        messageQueues[appData.name] = {}
                        AppButton[ResolveAppName(appData.name)]:setBackground(colors.gray)
                        ResetNotificationcenter()

                        -- Add close button
                        sub[newApp[appData.index].sub]:addButton()
                            :setText("X")
                            :setPosition("parent.w - 2",1)
                            :setSize(3,1)
                            :setBackground(16384)
                            :onClick(function(self,event,button,x,y)
                                if (event=="mouse_click") and (button==1) then
                                    menubar:removeItem(wdh + 1)
                                    newApp[appData.index].sub = 0
                                    programs[appData.name] = nil
                                    openSubFrame(1)
                                    menubar:selectItem(1)
                                end
                            end)
                    end
                end
            end)
        )
    end


    --Popup
    function Popup(color,label, btn1, btn2)
        local popup = main:addMovableFrame():setBackground(color):setSize("parent.w / 2", "parent.h / 2"):setPosition("parent.w / 4", "parent.h / 4")
        popup:addPane():setSize("parent.w", 1):setBackground(false,"\45", colors.black):setPosition(1, 1)
        popup:addButton():setText("X"):setPosition("parent.w - 2",1):setSize(3,1):setBackground(16384)
                            :onClick(function(self,event,button,x,y)
                                if (event=="mouse_click") and (button==1) then
                                    popup:setZIndex(-10)
                                    popup:remove()
                                    os.queueEvent("popup_return_event", 0)
                                end
                            end)
        
        local container = popup:addScrollableFrame():setSize("parent.w - 2", 4):setPosition(2, 2):setBackground(color)
        local labelText = label
        local function wrapText(text, width)
            local lines = {}
            for line in text:gmatch("[^\n]+") do
                while #line > width do
                    local spacePos = line:sub(1, width):match(".*()%s")
                    if not spacePos or spacePos < width / 2 then
                        spacePos = width
                    end
                    table.insert(lines, line:sub(1, spacePos))
                    line = line:sub(spacePos + 1):match("^%s*(.*)$") or ""
                end
                table.insert(lines, line)
            end
            return lines
        end
        local labelWidth = container:getWidth()  -- actual width in characters
        local wrapped = wrapText(labelText, labelWidth)
        local neededHeight = #wrapped
        container:addLabel():setText(label):setSize("parent.w", neededHeight)
        local flex = popup:addFlexbox():setBackground(color):setPosition(2, 6):setSpacing(0):setDirection("column"):setJustifyContent("flex-end"):setSize("parent.w", "parent.h - 6")
        local buttonflex = flex:addFlexbox():setBackground(color):setSize("parent.w - 1", 3):setJustifyContent("center")
        if not btn1 == false then
            buttonflex:addButton():setText(btn1):setFlexBasis(1):setFlexGrow(1):onClick(function(self,event,button,x,y)
                                    if (event=="mouse_click") and (button==1) then
                                        popup:setZIndex(-10)
                                        popup:remove()
                                        os.queueEvent("popup_return_event", 1)
                                    end
                                end)
            if not btn2 == false then
                buttonflex:addButton():setText(btn2):setFlexBasis(1):setFlexGrow(1):onClick(function(self,event,button,x,y)
                                        if (event=="mouse_click") and (button==1) then
                                            popup:setZIndex(-10)
                                            popup:remove()
                                            os.queueEvent("popup_return_event", 2)
                                        end
                                    end)
            end
        end
    end
    basalt.onEvent(function(event, ...)
        if event == "popup_event" then
            local color, label, btn1, btn2 = ...
            Popup(color, label, btn1, btn2)
        end
    end)
    
    -- Bottom status bar frames
    local botframe = main:addFrame():setPosition(0 ,"parent.h"):setSize("parent.w"):setBackground(colors.black):setForeground(colors.white)
    local clockframe = main:addFrame():setPosition(1,"parent.h"):setSize("parent.w"):setBackground(colors.black):setForeground(colors.white)
    local connframe = main:addFrame():setPosition("parent.w - 3","parent.h"):setSize("parent.w"):setBackground(colors.black):setForeground(colors.white)
    clockframe:setImportant()



    -- Clock UI
    local clock = clockframe:addLabel()
    local clocktype = settings.get("general.timeFormat")
    if (clocktype == 2) then clock:setText(os.date("%X")) end
    if (clocktype == 3) then
        local time = os.time()
        local formattedTime = textutils.formatTime(time, true)
        clock:setText(formattedTime)
    end

    -- Connection status label
    local conn = connframe:addLabel()
    conn:setText("IIII")

    --local function getConn()
    --    while true do
    --        while not network.isConnected() do
    --           conn:setText("I")
    --           conn:show()
    --            sleep(1)
    --            conn:hide()
    --            sleep(1)
    --        end
    --        while network.isConnected() do
    --           conn:setText("IIII")
    --           conn:show()
    --        end
    --    end
    --end

    -- Clock update loop
    local function clockRun()
        while true do
            local clocktype = settings.get("general.timeFormat")
            if (clocktype == 1) then
                clock:setText(os.date("%X"))
            elseif (clocktype == 2) then
                local time = os.time()
                local formattedTime = textutils.formatTime(time, true)
                clock:setText(formattedTime)
            end
            sleep(1)
        end
    end

    -- Auto-update computer label from settings
    local function getLabel()
        while true do
            local Label = settings.get("general.Label")
            os.setComputerLabel(Label)
            sleep(1)
        end    
    end

    -- Global program event handler
    basalt.onEvent(function(event, ...)
        if event == "program_event" then
            local targetID, app, param, data = ...
            Log("Received event from Program to: " .. targetID .."(" .. app .. "), with params " .. param .. " and data " .. data, "DEV")
            network.send(targetID, app, param, data)
        end
    end)

    
    -- Start UI loop, clock updater, and label updater
    parallel.waitForAll(basalt.autoUpdate, clockRun, getLabel, network.loop)
end