--[[
    DO NOT FORGET TO ALLOW HAMMERSPPON TO CONTROL YOUR MAC:
    https://github.com/Hammerspoon/hammerspoon/issues/1984#issuecomment-481272133
]]


-- To reload the script (put first so it's always enabled)

hs.hotkey.bind({"cmd", 'alt'}, 'r', function()
    hs.reload()
end)


local log = hs.logger.new('mymodule','debug')


-- Loading all modules defining shortcuts

require "app_tab_launcher";
require "code_expander";
require "contextual_actions";
require "interview";
require "search";
require "test";

hs.loadSpoon("Spoons/CopyWatcher"):max_size(20):start():bindTo({"cmd", "alt"}, "e")


-- ****************************************************


-- TODO: interesting to track time
-- https://www.hammerspoon.org/docs/hs.application.watcher.html


-- TODO: play with HTTP requests
-- https://www.hammerspoon.org/docs/hs.http.html


-- TODO: answer to URL events
-- https://www.hammerspoon.org/docs/hs.urlevent.html


-- TODO: run tasks
-- https://www.hammerspoon.org/docs/hs.task.html
