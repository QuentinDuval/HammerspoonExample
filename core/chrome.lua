
--[[
    Module to interact with Chrome
]]


require "core.menu_search"


function new_chrome_tab_with(address)
    local browser = hs.application.open("Google Chrome", 0.1, true)
    browser:activate()
    hs.eventtap.keyStroke({"cmd"}, "t") -- open a new tab
    -- hs.eventtap.keyStrokes(address) -- search in google
    write_lines(address) -- Much faster than the key strokes
    hs.eventtap.keyStroke({}, "return") -- validate auto completion
    hs.eventtap.keyStroke({}, "return") -- run the search
end


function new_chrome_tab_right_with(address)
    local browser = hs.application.open("Google Chrome", 0.1, true)
    browser:activate()
    -- Requires to set the correct shortcut in:
    -- System preferences > Keyboard > Shortcut > Application shortcuts
    hs.eventtap.keyStroke({"cmd", "ctrl", "alt"}, "t") -- open a new tab to the right
    write_lines(address) -- Much faster than the key strokes
    hs.eventtap.keyStroke({}, "return") -- validate auto completion
    hs.eventtap.keyStroke({}, "return") -- run the search
end


function chrome_switch_to_tab(pattern, if_no_found)
    --[[
        Switch to an existing tab or open a new tab with the address
        'if_no_found' (optional) in case the tab does not exist
    ]]
    
    -- Does not work for chrome: API for tabs not supported...
    -- local w = ap:focusedWindow()
    -- hs.alert(w:tabCount())

    -- Does not work with Chrome: only current window returned...
    -- for i, w in ipairs(ap:allWindows()) do
    --     hs.alert(w:title())
    -- end

    -- So the technique is to search the Tabs menu, but the following
    -- will likely fail (it will search "recently closed" first)
    -- local item = ap:findMenuItem(pattern)

    -- So the technique is to search the "Tabs" menu manually

    -- TODO:
    --  * the tabs are grouped by window (to be improved)
    --  * the windows are however available in "Windows" menu

    local ap = hs.application.find("Google Chrome")
    ap:activate(true)
    local onglets = get_application_menu(ap, "Tab")
    local item = search_menu(onglets, pattern)
    if (item) then
        ap:selectMenuItem({"Tab", item.AXTitle})
    elseif (if_no_found) then
        ap:selectMenuItem("New Tab")
        hs.eventtap.keyStrokes(if_no_found)
        hs.eventtap.keyStroke({}, "return") -- validate auto completion
        hs.eventtap.keyStroke({}, "return") -- run the search
    end
end