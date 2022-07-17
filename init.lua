--[[
    DO NOT FORGET TO ALLOW HAMMERSPPON TO CONTROL YOUR MAC:
    https://github.com/Hammerspoon/hammerspoon/issues/1984#issuecomment-481272133
]]


-- To reload the script (put first so it's always enabled)

hs.hotkey.bind({"cmd", 'alt'}, 'r', function()
    hs.reload()
end)

-- Loading all modules defining shortcuts

require "app_tab_launcher";
require "interview";
require "project.actions";
require "test";


-- Loading all the spoons

hs.loadSpoon("Spoons/CopyWatcher"):max_size(20):start():bindTo({"cmd", "alt"}, "e")
hs.loadSpoon("Spoons/QuickSearch"):bindTo({"cmd", "alt"}, "s")


-- Window management


hs.hotkey.bind({"cmd", "ctrl", "alt"}, "up", function()
    -- local window = hs.window.focusedWindow()
    local window = hs.window.frontmostWindow()
    window:setFullScreen(not window:isFullScreen())
end)

hs.hotkey.bind({"cmd", "ctrl", "alt"}, "down", function()
    local window = hs.window.frontmostWindow()
    if window:isFullScreen() then
        window:setFullScreen(false)
    else
        window:sendToBack()
    end
end)

--[[
hs.hotkey.bind({"cmd", "ctrl", "alt"}, "right", function()
    local window = hs.window.frontmostWindow()
    hs.alert.show(window:screen())
    -- spaces is what you are looking for, not screens
end)
]]


-- ****************************************************


-- TODO: interesting to track time
-- https://www.hammerspoon.org/docs/hs.application.watcher.html


-- TODO: play with HTTP requests
-- https://www.hammerspoon.org/docs/hs.http.html


-- TODO: answer to URL events
-- https://www.hammerspoon.org/docs/hs.urlevent.html


-- TODO: run tasks
-- https://www.hammerspoon.org/docs/hs.task.html
