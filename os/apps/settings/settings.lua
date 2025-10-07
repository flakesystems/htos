local basalt = require("_basalt")
local handler = require("_handler")
local versionfile = fs.open("version.txt", "r")
local version = versionfile.readAll()
versionfile.close()

local main = basalt.createFrame():setTheme({FrameBG = colors.lightGray, FrameFG = colors.black})

local sub = { -- here we create a table where we gonna add some frames
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h"), -- obviously the first one should be shown on program started
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h"):hide(),
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h"):hide(),
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h"):hide(),
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h"):hide(),
    main:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h"):hide(),
}

local function openSubFrame(id) -- we create a function which switches the frame for us
    if(sub[id]~=nil)then
        for k,v in pairs(sub)do
            v:hide()
        end
        sub[id]:show()
    end
end

--Main Page

local page = sub[1]:addFlexbox():setPosition(2, 1):setSize("parent.w", "parent.h - 1")

--Breadcrumbs

local breadcrumbs = page:addFlexbox():setSpacing(0):setSize("parent.w", 1):setWrap("wrap")

local devclicker = 0

breadcrumbs:addLabel():setText("Settings"):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        devclicker = devclicker + 1
        if devclicker == 5 then
            if settings.get("dev.enabled") == true then
                if handler.popup(colors.orange,"Do you want to disable Developer Mode?","Yes","No") == 1 then
                    settings.set("dev.enabled",false)
                    settings.save(".settings")
                end
            elseif handler.popup(colors.green,"Do you want to enable Developer Mode?","Yes","No") == 1 then
                settings.set("dev.enabled",true)
                settings.save(".settings")
            end
            devclicker = 4
        end
        
    end
end)

page:addBreak()

--Content

local flex = sub[1]:addFlexbox():setWrap("wrap"):setSize("parent.w","parent.h - 3"):setPosition(2, 3)

--Button Section

flex:addButton():setText("General"):setSize(10,3):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        openSubFrame(2)
    end
  end)
  flex:addButton():setText("Info"):setSize(10,3):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        openSubFrame(3)
    end
  end)
  flex:addButton():setText("Account"):setSize(10,3):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        openSubFrame(4)
    end
  end)
  flex:addButton():setText("Apps"):setSize(10,3):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        openSubFrame(5)
    end
  end)
  flex:addButton():setText("Logs"):setSize(10,3):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        openSubFrame(6)
    end
  end)

--Sub Pages

--General(2)

local page = sub[2]:addFlexbox():setPosition(2, 1):setSize("parent.w", "parent.h - 1"):setWrap("wrap"):setSpacing(0)

page:addLabel():setText("General ")

--Back

local back = page:addButton():setText("Back"):setSize("self.w / 2", 1):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        openSubFrame(1)
    end
  end)

  local backPosx, backPosy = back:getPosition()

page:addBreak()

local flex = sub[2]:addFlexbox():setWrap("wrap"):setSize("parent.w","parent.h - 2"):setPosition(2, 3):setSpacing(-1)

local function onBackReposition()
    local x, y = back:getPosition()
    local newPos = y - backPosy
    if (newPos > 0) then
        flex:setPosition(2, 5)
    end
    if (newPos == 0) then
        flex:setPosition(2, 3)
    end
end

back:onReposition(onBackReposition)

--Content

flex:addLabel():setText("Set Time Format:")
flex:addBreak()

local function changeTimeFormat(index)
    settings.set("general.timeFormat",index)
    settings.save(".settings")
end


local timeFormat = flex:addList():setSize("self.w",2)
timeFormat:addItem("IRL")
timeFormat:addItem("MC")
timeFormat:selectItem(settings.get("general.timeFormat"))
timeFormat:onChange(function(self, val)
    changeTimeFormat(self:getItemIndex()) -- here we open the sub frame based on the table index
end)
  flex:addBreak()
  flex:addLabel():setText("")
  flex:addBreak()
  flex:addLabel():setText("")
  flex:addBreak()
  flex:addLabel():setText("Set Label:")
  flex:addBreak()
 local LabelInput = flex:addInput()
 LabelInput:setInputType("text")
LabelInput:setInputLimit(20)
LabelInput:setValue(settings.get("general.Label"))

local function LabelOnChange(self, event, value)
    settings.set("general.Label", value)
    settings.save()
  end

LabelInput:onChange(LabelOnChange)

--Info(3)

local page = sub[3]:addFlexbox():setPosition(2, 1):setSize("parent.w - 2", "parent.h - 1"):setWrap("wrap"):setSpacing(0)

page:addLabel():setText("Info ")

--Back

local back = page:addButton():setText("Back"):setSize("self.w / 2", 1):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        openSubFrame(1)
    end
  end)

local backPosx, backPosy = back:getPosition()

page:addBreak()

local flex = sub[3]:addFlexbox():setWrap("wrap"):setSize("parent.w - 2","parent.h - 2"):setPosition(2, 3):setSpacing(-1)

local function onBackReposition()
    local x, y = back:getPosition()
    local newPos = y - backPosy
    if (newPos > 0) then
        flex:setPosition(2, 5)
    end
    if (newPos == 0) then
        flex:setPosition(2, 3)
    end
end

back:onReposition(onBackReposition)

--Content

flex:addLabel():setText("Mofilbunk:")
flex:addBreak()
flex:addLabel():setText("Provider:"):setForeground(colors.gray)
flex:addBreak()
flex:addLabel():setText("HT-Mobile"):setForeground(colors.gray)
flex:addBreak()
flex:addLabel():setText("Version:"):setForeground(colors.gray)
flex:addBreak()
flex:addLabel():setText("mbf-version"):setForeground(colors.gray)

flex:addLabel():setText(""):setForeground(colors.gray)
flex:addBreak()
flex:addPane():setSize("parent.w - 2", 1):setBackground(false, "\140", colors.gray):setFlexGrow(1):setFlexShrink(1):setFlexBasis(-1)
flex:addLabel():setText(""):setForeground(colors.gray)
flex:addBreak()


flex:addLabel():setText("Device:")
flex:addBreak()
flex:addLabel():setText("ID:"):setForeground(colors.gray)
flex:addBreak()
flex:addLabel():setText(os.getComputerID()):setForeground(colors.gray)
flex:addBreak()
flex:addLabel():setText("Label:"):setForeground(colors.gray)
flex:addBreak()
local displayLabel = flex:addLabel():setForeground(colors.gray)
local function updateLabel()
    while true do
        displayLabel:setText(os.getComputerLabel()):setForeground(colors.gray)
        sleep(1)
    end
end
flex:addBreak()
flex:addLabel():setText("HTos Version:"):setForeground(colors.gray)
flex:addBreak()
flex:addLabel():setText(version):setForeground(colors.gray)


--Account(4)

local page = sub[4]:addFlexbox():setPosition(2, 1):setSize("parent.w - 2", "parent.h - 1"):setWrap("wrap"):setSpacing(0)
page:addLabel():setText("Account ")

--Back

local back = page:addButton():setText("Back"):setSize("self.w / 2", 1):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        openSubFrame(1)
    end
  end)

local backPosx, backPosy = back:getPosition()

page:addBreak()

local flex = sub[4]:addScrollableFrame():setSize("parent.w - 2","parent.h - 4"):setPosition(2, 2)

local function onBackReposition()
    local x, y = back:getPosition()
    local newPos = y - backPosy
    if (newPos > 0) then
        flex:setPosition(2, 5)
    end
    if (newPos == 0) then
        flex:setPosition(2, 3)
    end
end

back:onReposition(onBackReposition)

--Content

flex:addLabel():setText("Work in progress...")

--Apps(5)

local page = sub[5]:addFlexbox():setPosition(2, 1):setSize("parent.w - 2", "parent.h - 1"):setWrap("wrap"):setSpacing(0)
page:addLabel():setText("Apps ")

--Back

local back = page:addButton():setText("Back"):setSize("self.w / 2", 1):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        openSubFrame(1)
    end
  end)

local backPosx, backPosy = back:getPosition()

page:addBreak()

local flex = sub[5]:addFlexbox():setSize("parent.w - 2","parent.h - 4"):setPosition(2, 2):setDirection("column")

local function onBackReposition()
    local x, y = back:getPosition()
    local newPos = y - backPosy
    if (newPos > 0) then
        flex:setPosition(2, 5)
    end
    if (newPos == 0) then
        flex:setPosition(2, 3)
    end
end

back:onReposition(onBackReposition)

--Content

        local item = {}
        local perms = {}
        local entries = {}
        -- Scan /os/apps directory and register each .lua file as an app
        for i, file in ipairs(fs.list("/os/apps")) do
            table.insert(item, flex:addFrame():setSize("parent.w", 3):setBackground(colors.cyan))
            table.insert(perms, main:addFrame():setSize("parent.w", "parent.h"):setPosition("parent.w + 1", 1):setBackground(colors.white))
            local name = string.gsub(file,".lua","")
            item[i]:addLabel():setText(name):setPosition(1, 2)
            item[i]:addButton():setText("Permissions"):setSize(13, 3):setPosition("parent.w - 21", 1):onClick(function(self,event,button,x,y)
                if(event=="mouse_click")and(button==1)then
                    local temp = perms[i]:getX()
                    perms[i]:animatePosition(1, 1, 1)
                    perms[i]:addButton():setText("<-"):setPosition(1,1):setSize(4,1):setBackground(colors.gray):onClick(function(self,event,button,x,y)
                        if (event=="mouse_click") and (button==1) then
                            perms[i]:animatePosition(temp, 1, 1)
                        end
                    end)
                    perms[i]:addLabel():setText(name):setSize("parent.w - 1"):setTextAlign("center")
                    local content = perms[i]:addFlexbox():setPosition(2, 3):setSize("parent.w - 2", "parent.h - 2"):setDirection("column")

                    local appPath = "/os/apps/" .. file

                    local s = settings.getNames()
                    local found = false

                    for _, key in ipairs(s) do
                        local match = key:match("^perms%.@(/.-)%.os/apps/" .. file:gsub("([%.%-%+%*%?%[%]%^%$%%])", "%%%1") .. "$")

                        if match then
                            found = true
                            
                            local entry = content:addFrame():setSize("parent.w", 3):setBackground(colors.cyan)
                            table.insert(entries, entry)
                            entry:addLabel():setText(match):setPosition(1, 2)
                            entry:addButton():setText("Revoke"):setBackground(colors.red):setSize(8, 3):setPosition("parent.w - 7", 1):onClick(function(self,event,button,x,y)
                                if (event=="mouse_click") and (button==1) then
                                    if print(handler.popup(colors.red, "Are you sure you want to revoke " .. match .. " from " .. name .. "?","Revoke","Cancel")) == 1 then
                                        settings.unset(key)
                                        settings.save()
                                        entry:hide()
                                        entry:remove()
                                    end
                                end
                            end)

                        end
                    end
                    
                    if not found then
                        content:addLabel():setText("No permissions found."):setTextAlign("center"):setSize("parent.w", 1)
                    end
                end
            end)
            item[i]:addButton():setText("Delete"):setBackground(colors.red):setSize(8, 3):setPosition("parent.w - 7", 1):onClick(function(self,event,button,x,y)
                if (event=="mouse_click") and (button==1) then
                    if print(handler.popup(colors.red, "Are you sure you want to uninstall " .. name .. "? Your System will reload. Any unsaved changes will be lost!","Proceed","Cancel")) == 1 then
                        local appPath = "/os/apps/" .. file
                        fs.delete(appPath)
                        handler.fastreboot()
                    end
                end
            end)
        end
    

flex:onResize(function()
    for _, item in ipairs(item) do
        item:setSize("parent.w", 3)
    end
    for _, entry in ipairs(entries) do
        entry:setSize("parent.w", 3)
    end
end)

--Logs(6)

local page = sub[6]:addFlexbox():setPosition(2, 1):setSize("parent.w - 2", "parent.h - 1"):setWrap("wrap"):setSpacing(0)

page:addLabel():setText("Logs ")

--Back

local back = page:addButton():setText("Back"):setSize("self.w / 2", 1):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        openSubFrame(1)
    end
  end)

local backPosx, backPosy = back:getPosition()
page:addLabel():setText(" ")
local showtime = page:addButton():setText("Show Timecode"):setSize(15, 1)

page:addBreak()

local flex = sub[6]:addScrollableFrame():setSize("parent.w - 2","parent.h - 4"):setPosition(2, 2)

local function onBackReposition()
    local x, y = back:getPosition()
    local newPos = y - backPosy
    if (newPos > 0) then
        flex:setPosition(2, 5)
    end
    if (newPos == 0) then
        flex:setPosition(2, 3)
    end
end

back:onReposition(onBackReposition)

--Content

local showtimecode = 0


local logdisplay = flex:addProgram():setSize("parent.w - 1", "parent.h")

logdisplay:execute("/os/objects/system/logdisplay.lua")

function UpdateLogs(value)
    logdisplay:injectEvent("log_update", false, 0, value)
end

showtime:onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        if showtimecode == 0 then
            showtime:setText("Hide Timecode")
            showtimecode = 1
            UpdateLogs(1)
        elseif showtimecode == 1 then
            showtime:setText("Show Timecode")
            showtimecode = 0
            UpdateLogs(0)
        end
    end
  end)

--Update


parallel.waitForAll(basalt.autoUpdate, updateLabel)