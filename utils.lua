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

function pop_up_menu_at_mouse(menu_items)
    local menubar = hs.menubar.new()
    menubar:setMenu(menu_items)
    local position_point = hs.mouse.getAbsolutePosition()
    menubar:popupMenu(position_point)
end


-- *****************************
-- Example to run apple script
-- *****************************


function run_apple_script()
    ok,result = hs.applescript('tell Application "Chrome" to open location "http://www.google.fr"')
    hs.alert.show(result)
end