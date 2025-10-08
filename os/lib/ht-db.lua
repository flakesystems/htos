local db = {}

function db.create(name, path)
    if not path then
        path = "/os/storage/db"
    end 
    if not fs.exists(path .. name .. ".db", "w") and string.sub(path, -1) == "/" then
        db = fs.open(path .. name .. ".db", "w")
        db.close()
    elseif not fs.exists(path .. "/" .. name .. ".db", "w") then
        db = fs.open(path .. "/" .. name .. ".db", "w")
        db.close()
    else
        return "database already exists"
    end
end




return db