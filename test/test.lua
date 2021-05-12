lcpp = require "lcpp"

constants = lcpp.include("foo.h", {"test/inc"})

names = {}
for name, _ in pairs(constants) do table.insert(names, name) end
table.sort(names)

for _, name in ipairs(names) do
    local val = constants[name]
    print(name, val, type(val))
end
