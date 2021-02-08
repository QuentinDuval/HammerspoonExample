--[[
    Utilities to interact with PyCharm
]]

require "core.menu_search";


local log = hs.logger.new('core.pycharm','debug')


-- Show tabs with all windows in the PyCharm title bar
hs.tabs.enableForApp("PyCharm")


-- Define a window filter that watches the PyCharm windows
-- (because hs.application:allWindows() only return windows in the current space)
-- Note that it does not work perfectly either: the filter usually retains only the last one
local pycharm_wf = hs.window.filter.new{"PyCharm"}
pycharm_wf:setAppFilter("PyCharm", {})
pycharm_wf:setCurrentSpace(nil)  -- allow all spaces to be watched
-- local default_wf = hs.window.filter.default
-- default_wf:setCurrentSpace(nil)


function get_pycharm_windows()
    -- local ap = hs.application.find("PyCharm")
    -- local windows = ap:allWindows()
    local windows = pycharm_wf:getWindows(hs.window.filter.sortByFocused)
    return hs.fnutils.map(windows, function(window)
        return window:title()
    end)
end


function switch_to_pycharm_window(pattern)
    -- local ap = hs.application.find("PyCharm")
    -- local window = ap:findWindow(pattern)
    local windows = pycharm_wf:getWindows(hs.window.filter.sortByFocused)
    local window = hs.fnutils.find(windows, function(window)
        return window:title() == pattern
    end)
    window:focus()
end


function pycharm_open_new_ssh_terminal()
    local ap = hs.application.find("PyCharm")
    ap:selectMenuItem({"Tools", "Start SSH Session"})
    -- TODO: select the right connection
    hs.eventtap.keyStroke({}, "down")
    hs.eventtap.keyStroke({}, "down")
    hs.eventtap.keyStroke({}, "return")
end


function pycharm_interpreter()
    local ap = hs.application.find("PyCharm")
    local success = ap:selectMenuItem("Preferences...")
    if (success) then
        hs.timer.doAfter(0.5, function()
            hs.eventtap.keyStrokes("Interpreter")
        end)
    end
end


function pycharm_upload_diff()
    -- TODO
    -- might be a good use case for:
    -- https://www.hammerspoon.org/docs/hs.pathwatcher.html
end
