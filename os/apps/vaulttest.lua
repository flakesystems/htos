local vault = require("/os/lib/vault")

vault.create("Test")
vault.store("Test", "Testwert", "Test")
print(vault.get("Test", "Test"))