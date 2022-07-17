-- *****************************
-- Table helpers
-- *****************************

function table.clone(org)
    -- local out = {table.unpack(org)}  -- Deals with the normal arrays only
    local out = {}
    for k, v in pairs(org) do
        out[k] = v
    end
    return out
end

function table.clear(xs)
    local count = #xs
    for i = 0, count do
        xs[i] = nil
    end
end

function table.reverse(t)
    local n = #t
    local i = 1
    while i < n do
        t[i], t[n] = t[n], t[i]
        i = i + 1
        n = n - 1
    end
end

function table.slice(xs, first, last, step)
    local sliced = {}
    step = step or 1
    if last < 0 then
        last = #xs + last
    end
    for i = first, last or #xs, step do
        table.insert(sliced, xs[i])
    end
    return sliced
end

function table.merge_dicts(first_table, second_table)
    for k, v in pairs(second_table) do
        first_table[k] = v
    end
    return first_table
end

--- Add default values to the first table
-- @param first_table fields to keep
-- @param defaults fields to add if missing
-- @return a new table merging those
function table.add_defaults(first_table, defaults)
    local output = {}
    for k, v in pairs(defaults) do
        output[k] = v
    end
    for k, v in pairs(first_table) do
        output[k] = v
    end
    return output
end

function table.enumerate(t)
    return ipairs(t)
end

function table.length(t)
    return #t
end

function table.transform(t, fct)
    local output = {}
    for i, v in ipairs(t) do
        table.insert(output, fct(v))
    end
    return output
end

function table.filter(t, pred)
    local output = {}
    for i, v in ipairs(t) do
        if pred(v) then
            table.insert(output, v)
        end
    end
    return output
end

function table.zip(x, y)
    local m = #x
    local n = #y
    local i = 1
    return function()
        if (i > n or i > m) then
            return nil
        else
            local v1 = x[i]
            local v2 = y[i]
            i = i + 1
            return v1, v2
        end
    end
end

function table.combinations(possibilities)
    local combis = {{}}
    for i, possible in ipairs(possibilities) do
        local name = possible.name
        local values = possible.values
        local next_combis = {}
        for j, value in ipairs(values) do
            for k, combi in ipairs(combis) do
                local next_combi = table.clone(combi)
                next_combi[name] = value
                table.insert(next_combis, next_combi)
            end
        end
        combis = next_combis
    end
    return combis
end


-- *****************************
-- String helpers
-- *****************************

function string.is_empty(s)
    return s == nil or s == ''
end

function string.startswith(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function string.join(delimiter, list)
    local len = #list
    if len == 0 then
        return ""
    end
    local string = list[1]
    for i = 2, len do
        string = string .. delimiter .. list[i]
    end
    return string
end

function string.strip(str)
    return str:match("^%s*(.-)%s*$")
end

function string.split(input_str, sep)
    if sep == nil then
        sep = "%s"
    end
    local output = {}
    for str in string.gmatch(input_str, "([^" .. sep .. "]+)") do
        table.insert(output, str)
    end
    return output
end

--- dedent a multiline string by removing any initial indent.
-- useful when working with [[..]] strings.
-- @param s the string
-- @return a string with initial indent zero.
function string.dedent(s)
    local lines = string.split(s, '\n')
    local i1, i2 = lines[1]:find('^%s*')
    lines = hs.fnutils.imap(lines, function(line)
        return string.sub(line, i2+1)
    end)
    return string.join('\n', lines)                
end                 


-- *****************************
-- File helpers
-- *****************************

function io.read_file(file_path)
    local file = io.open(file_path, 'r')
    assert(file)
    local content = file:read('*a')
    file:close()
    return content
end

function io.iter_lines(file_path)
    return io.lines(file_path)
end

-- *****************************
-- Copy paste helpers
-- *****************************

function copy()
    hs.eventtap.keyStroke({"cmd"}, "c")
end

function paste()
    hs.eventtap.keyStroke({"cmd"}, "v")
end

function backup_pasteboard()
    hs.pasteboard.setContents(hs.pasteboard.getContents(), "TEMP")
end

function restore_pasteboard()
    hs.pasteboard.setContents(hs.pasteboard.getContents("TEMP"))
end

function with_temporary_copy(fn)
    backup_pasteboard()
    fn()
    restore_pasteboard()
end

function get_selected_text()
    return hs.pasteboard.getContents()
end

function copy_selected_text()
    copy()
    return get_selected_text()
end

function get_window_name()
    local window = hs.window.focusedWindow()
    if window then
        return window:title()
    else
        return ""
    end
end

-- *****************************
-- Write text helpers
-- *****************************

function enter_in_command_line(text)
    hs.eventtap.keyStrokes(text)
    hs.eventtap.keyStroke({}, "return")
end

function doKeyStroke(modifiers, character)
    -- In case hs.eventtap.keyStroke does not work
    if type(modifiers) == 'table' then
        local event = hs.eventtap.event

        for _, modifier in pairs(modifiers) do
            event.newKeyEvent(modifier, true):post()
        end

        event.newKeyEvent(character, true):post()
        event.newKeyEvent(character, false):post()

        for i = #modifiers, 1, -1 do
            event.newKeyEvent(modifiers[i], false):post()
        end
    end
end

function write_lines(text_with_lines)
    with_temporary_copy(function()
        hs.pasteboard.writeObjects(text_with_lines)
        paste()
    end)
end

-- *****************************
-- Windows helpers
-- *****************************

function focused_window_name_contains(text)
    local window_name = get_window_name()
    return window_name:find(text) and window_name:find(text) > 0
end

-- *****************************
-- Example to run apple script
-- *****************************

function run_apple_script()
    ok, result = hs.applescript('tell Application "Chrome" to open location "http://www.google.fr"')
    hs.alert.show(result)
end
