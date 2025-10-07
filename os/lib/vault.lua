local handler = require("/handler")

local vault = {}

function Hash(str)
  local hash = 5381
  for i = 1, #str do
    local c = string.byte(str, i)
    hash = (hash * 33 + c) % 4294967296 -- 2^32 to simulate 32-bit wrap
  end
  return string.format("%08X", hash)
end

local bit = bit or bit32

function Encrypt(text, key)
  local out = {}
  for i = 1, #text do
    local t = text:byte(i)
    local k = key:byte((i - 1) % #key + 1)
    local x = bit.bxor(t, k)
    out[#out+1] = string.format("%02X", x)
  end
  return table.concat(out)
end

function Decrypt(hex, key)
  local out = {}
  for i = 1, #hex, 2 do
    local x = tonumber(hex:sub(i, i+1), 16)
    local ki = math.floor((i - 1) / 2) % #key + 1
    local k = key:byte(ki)
    out[#out+1] = string.char(bit.bxor(x, k))
  end
  return table.concat(out)
end


function vault.create(filename)
  if handler.checkperms() then
    local vaultfile = Hash(filename)
    if not fs.exists("/os/vault/" .. vaultfile .. ".vlt") then
      local new = fs.open("/os/vault/" .. vaultfile .. ".vlt", "w")
        new.close()
    end
  end
end

function vault.store(filename, value, key)
  if handler.checkperms() then
    local vaultfile = Hash(filename)
    if fs.exists("/os/vault/" .. vaultfile .. ".vlt") then
      local file = fs.open("/os/vault/" .. vaultfile .. ".vlt", "w+")
      file.write(Encrypt(value, key))
      file.close()
    end
  end
end

function vault.get(filename, key)
  if handler.checkperms() then
  local vaultfile = Hash(filename)
    if fs.exists("/os/vault/" .. vaultfile .. ".vlt") then
      local file = fs.open("/os/vault/" .. vaultfile .. ".vlt", "r")
      local data = file.readAll()
      file.close()
      return Decrypt(data, key)
    end
  end
end

return vault