local handler = require("/_handler")
local basalt = require("/_basalt")

local main = basalt.createFrame():setTheme({FrameBG = colors.lightGray, FrameFG = colors.black})

local sidebar = main:addFrame():setBackground(colors.gray):setSize("parent.w / 4", "parent.h")

local body = {
        main:addFrame():setSize("parent.w / 2 + parent.w / 4", "parent.h"):setPosition("parent.w / 4 + 1", 1),
        main:addFrame():setBackground(colors.green):setSize("parent.w / 2 + parent.w / 4", "parent.h"):setPosition("parent.w / 4 + 1", 1):hide(),
        main:addFrame():setBackground(colors.blue):setSize("parent.w / 2 + parent.w / 4", "parent.h"):setPosition("parent.w / 4 + 1", 1):hide(),
        main:addFrame():setBackground(colors.purple):setSize("parent.w / 2 + parent.w / 4", "parent.h"):setPosition("parent.w / 4 + 1", 1):hide(),
    }

local function openSubFrame(id)
        if body[id] ~= nil then
            for _, v in pairs(body) do v:hide() end
            body[id]:show()
        end
    end

local navbar = sidebar:addList():setPosition(1, 2):setSize("parent.w", "parent.h")
        :onChange(function(self, val)
            openSubFrame(self:getItemIndex())
        end)
navbar:addItem(" Apps")
navbar:addItem(" Games")
navbar:addItem(" Updates")
if settings.get("dev.enabled") == true then
    navbar:addItem(" Dev")
end

--Apps

local properties = {{
    name = "Test",
    author = "Kuschelcraft",
    installer = "pastebin get ApLvEf5x os/apps/test3.lua",
    description = "This is a test app.",
    size = 1,
    monetarisation = {
    inapppurchases = true,
    ads = false
    },
    tags = {},
    collected_data = {},
    permissions = {
        "vault"
    }
},
{
    name = "Test2",
    author = "Kuschelcraft",
    installer = "",
    description = "This is test description with a longer Text for line wrapping test purposes. It should wrap properly and be scrollable if needed!",
    size = 146,
    monetarisation = {
    inapppurchases = false,
    ads = true
    },
    tags = {"test", "test2", "test3"},
    collected_data = {},
    permissions = {
        
    }
}
}

local page = body[1]:addFlexbox():setSize("parent.w", "parent.h"):setDirection("column"):setPosition(2, 2)
local item = {}
local detail = {}

for i, prop in ipairs(properties) do
    --create item
    table.insert(item, page:addFrame():setSize("parent.w + parent.w / 4", 15))
    --create detail container
    table.insert(detail, body[1]:addFrame():setSize("parent.w", "parent.h"):setPosition("parent.w + 1", 1):setBackground(colors.white))
    --add infos to item
    item[i]:addLabel():setText(" " .. prop.name):setSize("parent.w - 1"):setTextAlign("center"):setPosition(1,2)
    item[i]:addLabel():setText(prop.size .. "l."):setPosition(1,3):setSize("parent.w - 1"):setTextAlign("right")
    item[i]:addLabel():setText(prop.author):setPosition(2,3):setForeground(colors.gray)
    --add tags to item
    if #prop.tags <= 2 then
        if #prop.tags == 0 then
            item[i]:addPane():setSize("parent.w - 2", 1):setBackground(false, "\140", colors.black):setPosition(2,4):setZIndex(10)
            item[i]:addFrame():setSize("parent.w - 2", 9):setPosition(2,5):addLabel():setText(prop.description):setSize("parent.w", "parent.h")
        else
            local flex = item[i]:addFlexbox():setSize("parent.w - 2", 1):setPosition(2, 4):setWrap("wrap")
            for i, tag in ipairs(prop.tags) do
                flex:addButton():setText("test"):setSize("self.w", 1)
            end
            item[i]:addFrame():setSize("parent.w - 2", 8):setPosition(2,6):addLabel():setText(prop.description):setSize("parent.w", "parent.h")
        end
    else
        local flex = item[i]:addFlexbox():setSize("parent.w - 2", 3):setPosition(2, 4):setWrap("wrap")
        for i, tag in ipairs(prop.tags) do
            flex:addButton():setText("test"):setSize("self.w", 1)
        end
        item[i]:addFrame():setSize("parent.w - 2", 6):setPosition(2,8):addLabel():setText(prop.description):setSize("parent.w", "parent.h")
    end
    --details mechanic
    item[i]:addLabel():setText("Show more..."):setPosition(2,14):setForeground(colors.blue):onClick(function(self,event,button,x,y)
    if(event=="mouse_click")and(button==1)then
        local temp = detail[i]:getX()
        detail[i]:animatePosition(1, 1, 1)
        detail[i]:addButton():setText("<-"):setPosition(1,1):setSize(4,1):setBackground(colors.gray)
                            :onClick(function(self,event,button,x,y)
                                if (event=="mouse_click") and (button==1) then
                                    detail[i]:animatePosition(temp, 1, 1)
                                end
                            end)
        --details info
        detail[i]:addLabel():setText(prop.name):setSize("parent.w - 1"):setTextAlign("center")
        detail[i]:addLabel():setText(prop.size .. "l."):setPosition(1,2):setSize("parent.w - 1"):setTextAlign("right")
        detail[i]:addLabel():setText(prop.author):setPosition(2,2):setForeground(colors.gray)
        local content = detail[i]:addScrollableFrame():setPosition(2, 3):setSize("parent.w - 2", "parent.h - 2")
        --details tags
        if #prop.tags <= 2 then
            if #prop.tags == 0 then
                content:addPane():setSize("parent.w - 2", 1):setBackground(false, "\140", colors.black):setPosition(2,1):setZIndex(10)
                content:addFrame():setSize("parent.w - 2", 9):setPosition(2,2):addLabel():setText(prop.description):setSize("parent.w", "parent.h")
            else
                local flex = content:addFlexbox():setSize("parent.w - 2", 1):setPosition(2, 2):setWrap("wrap")
                for i, tag in ipairs(prop.tags) do
                    flex:addButton():setText("test"):setSize("self.w", 1)
                end
                content:addFrame():setSize("parent.w - 2", 8):setPosition(2,4):addLabel():setText(prop.description):setSize("parent.w", "parent.h")
            end
        else
            local flex = content:addFlexbox():setSize("parent.w - 2", 3):setPosition(2, 2):setWrap("wrap")
            for i, tag in ipairs(prop.tags) do
                flex:addButton():setText("test"):setSize("self.w", 1)
            end
            content:addFrame():setSize("parent.w - 2", 6):setPosition(2,6):addLabel():setText(prop.description):setSize("parent.w", "parent.h")
        end

    end
  end)
    --install button
    item[i]:addLabel():setText("Install"):setPosition(22,14):setForeground(colors.pink):onClick(function(self,event,button,x,y)
        if(event=="mouse_click")and(button==1)then
            if print(handler.popup(colors.red, "Your System will reload for the App to install. Any unsaved changes will be lost!","Proceed","Cancel")) == 1 then
                shell.run(prop.installer)
                handler.fastreboot()
            end
        end
    end)
    --set border
    item[i]:setBorder(colors.black):setZIndex(20)
end
page:addLabel():setText("")


--if print(handler.popup(colors.red, "Your System will reload for the App to install. Any unsaved changes will be lost!","Proceed","Cancel")) == 1 then
--    local file = fs.open("/os/apps/test.lua", "w")
--    file.write("print('test')")
--    file.close()
--    handler.fastreboot()
--end

basalt.autoUpdate()