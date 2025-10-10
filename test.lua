fs.makeDir("/os/apps/" .. "calc")
            shell.run("wget run https://raw.githubusercontent.com/flakesystems/htos/refs/heads/main/os/apps/calc/installer.lua")
            shell.run("/os/apps/calc/updater.lua")
            shell.setDir("/")