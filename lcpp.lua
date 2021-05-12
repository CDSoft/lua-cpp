local lcpp = {}

function lcpp.include(header_name, include_dirs)

    -- search for header_name in include_dirs

    include_dirs = include_dirs or {}
    local h, err = io.open(header_name)
    if not h then
        for _, dir in ipairs(include_dirs) do
            h = io.open(dir.."/"..header_name)
            if h then break end
        end
        assert(h, err)
    end
    local header = h:read("a")
    h:close()

    -- extract #defined constant names

    local var_names = {}
    header:gsub("#%s*define%s+(%w+)", function(var_name) table.insert(var_names, var_name) end)

    -- execute cpp on header_name and preprocess #defined constants

    local options = {}
    for _, dir in ipairs(include_dirs) do
        table.insert(options, "-I"..dir)
    end
    local tmp = os.tmpname()
    local p = assert(io.popen("cpp "..table.concat(options, " ").." > "..tmp, "w"))
    p:write(header)
    for _, var_name in ipairs(var_names) do
        p:write("'"..var_name.."' "..var_name.."\n")
    end
    assert(p:close())

    -- extract all constant values

    local h = assert(io.open(tmp))
    local vars = {}
    for l in h:lines() do
        l:gsub("'(%w+)' (.*)", function(name, val)
            local chunk = load("return "..val, nil, "t", {})
            if chunk then val = chunk() end
            vars[name] = val
        end)
    end
    h:close()

    os.remove(tmp)

    return vars

end

return lcpp
