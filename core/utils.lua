-- *****************************
-- String helpers
-- *****************************

function string.is_empty(s)
    return s == nil or s == ''
end

function string.split(inputstr, sep)
    sep = sep or "%s"
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

-- *****************************
-- File helpers
-- *****************************

function io.read_file(file_path)
    local file = io.open(file_path, 'r')
    local content = file:read('*a')
    file:close()
    return content
end


-- *****************************
-- List helpers
-- *****************************

function table.reverse(t)
    local n = #t
    local i = 1
    while i < n do
        t[i], t[n] = t[n], t[i]
        i = i + 1
        n = n - 1
    end
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


-- *****************************
-- Copy paste helpers
-- *****************************

function copy()
    hs.eventtap.keyStroke({"cmd"}, "c")
end

function paste()
    hs.eventtap.keyStroke({"cmd"}, "v")
end

function with_temporary_copy(fn)
    hs.pasteboard.setContents(hs.pasteboard.getContents(), "TEMP")
    fn()
    hs.pasteboard.setContents(hs.pasteboard.getContents("TEMP"))
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
