local basalt = require("/_basalt")

local mainFrame = basalt.createFrame()
local aProgram = mainFrame:addProgram()

aProgram:execute("rom/programs/shell.lua"):setSize("parent.w","parent.h") -- Executes the custom program

basalt.autoUpdate()