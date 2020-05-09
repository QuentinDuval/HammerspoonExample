-- DO NOT FORGET TO ALLOW HAMMERSPPON TO CONTROL YOUR MAC:
-- https://github.com/Hammerspoon/hammerspoon/issues/1984#issuecomment-481272133


-- *****************************
-- Helper functions
-- *****************************


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

function copy()
    hs.eventtap.keyStroke({"cmd"}, "c")
end

function paste()
    hs.eventtap.keyStroke({"cmd"}, "v")
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
-- Example to run apple script
-- *****************************


function run_apple_script()
    ok,result = hs.applescript('tell Application "Chrome" to open location "http://www.google.fr"')
    hs.alert.show(result)
end


-- *****************************
-- Search in the browser
-- *****************************


function search_in_google(content)
    local browser = hs.application.open("Google Chrome", 0.1, true)
    browser:activate()
    hs.eventtap.keyStroke({"cmd"}, "t") -- open a new tab
    hs.eventtap.keyStrokes("http://www.google.fr/search?q=" .. content) -- search in google
    hs.eventtap.keyStroke({}, "return") -- run the search
end


hs.hotkey.bind({"cmd", "alt"}, "s", function()
    local content = copy_selected_text()
    -- Demo on how to do pattern matching
    if content:find('DEF') == 1 then
        hs.alert.show("DEF")
    else
        search_in_google(content)
    end
end)


-- *****************************
-- Pop up a menu
-- *****************************


function on_search()
    local content = copy_selected_text()
    search_in_google(content)
end

function on_clicked()
    hs.alert.show("Clicked!")
end

hs.hotkey.bind({"cmd", "alt"}, "W", function()
    local window_name = get_window_name()
    local menubar = hs.menubar.new()
    menubar:setMenu({
        { title = "search", fn = on_search },
        { title = "-" },
        { title = window_name, fn = on_clicked },
    })
    local position_point = hs.mouse.getAbsolutePosition()
    menubar:popupMenu(position_point)
end)


-- *****************************
-- Reload the script
-- *****************************


hs.hotkey.bind({"cmd", 'alt'}, 'R', function()
    hs.reload()
end)
