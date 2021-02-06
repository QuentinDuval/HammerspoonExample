--[[
    DO NOT FORGET TO ALLOW HAMMERSPPON TO CONTROL YOUR MAC:
    https://github.com/Hammerspoon/hammerspoon/issues/1984#issuecomment-481272133
]]


-- To reload the script (put first so it's always enabled)

hs.hotkey.bind({"cmd", 'alt'}, 'r', function()
    hs.reload()
end)


-- Loading core utilities

require "core.utils";
require "core.pop_up_menu";


-- Loading all modules defining shortcuts

require "code_expander";
require "interview";
require "search";


-- ****************************************************
-- Logging
-- ****************************************************


local log = hs.logger.new('mymodule','debug')


-- *****************************
-- Searching the right tab
-- *****************************


function get_sub_item(items, name)
    for i, item in ipairs(items) do
        if item.AXTitle == name then
            return item
        end
    end
    return nil
end


function search_children(items, search)
    for i, list in ipairs(items) do
        for i, item in ipairs(list) do
            log:d(hs.inspect(item))
            if string.find(item.AXTitle, search) then
                return item
            end
        end
    end
    return nil
end


hs.hotkey.bind({"cmd", "alt"}, "x", function()

    -- open to focus on the window instead
    local ap = hs.application.find("Google Chrome")
    -- hs.alert(ap:name())
    -- hs.alert(ap:path())

    ap:activate(true)
    local w = ap:focusedWindow()
    -- local w = ap:findWindow("hammerspoon")
    -- hs.alert(w:title()) -- works
    -- hs.alert(w:isFullScreen()) -- works
    -- hs.alert(w:tabCount()) -- does not work for chrome...
    -- chrome_active_tab_with_name("Kilian")

    -- Not really working with Chrome: only one window returned, the current one
    -- for i, w in ipairs(ap:allWindows()) do
    --     hs.alert(w:title())
    -- end

    -- You can find a tab based on a regex search (but select first match)
    -- Typically, it will go into the "recently closed" first, which is not what I want
    -- local searched = "Boîte de réception.*Gmail.*"
    --[[
    local searched = "Watch.*"
    local item = ap:findMenuItem(searched, true)
    log:d(hs.inspect(item))
    hs.alert(item)
    if (item) then
        ap:selectMenuItem(searched, true)
    else
        ap:selectMenuItem("Nouvel onglet")
        hs.eventtap.keyStrokes("gmail.com")
        hs.eventtap.keyStroke({}, "return") -- validate auto completion
        hs.eventtap.keyStroke({}, "return") -- run the search
    end
    ]]--
    
    local items = ap:getMenuItems()
    items = get_sub_item(items, "Onglet")
    item = search_children(items.AXChildren, "Gmail")
    if (item) then
        ap:selectMenuItem({"Onglet", item.AXTitle})
    else
        ap:selectMenuItem("Nouvel onglet")
        -- ap:selectMenuItem({"Fichier", "Nouvel onglet"})
        hs.eventtap.keyStrokes("gmail.com")
        hs.eventtap.keyStroke({}, "return") -- validate auto completion
        hs.eventtap.keyStroke({}, "return") -- run the search
    end  
end)
