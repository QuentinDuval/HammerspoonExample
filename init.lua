--[[
    DO NOT FORGET TO ALLOW HAMMERSPPON TO CONTROL YOUR MAC:
    https://github.com/Hammerspoon/hammerspoon/issues/1984#issuecomment-481272133
]]


-- To reload the script (put first so it's always enabled)

hs.hotkey.bind({"cmd", 'alt'}, 'r', function()
    hs.reload()
end)


-- Loading core utilities

require "core.chrome"


-- Loading all modules defining shortcuts

require "code_expander";
require "interview";
require "search";


-- ****************************************************
-- Logging
-- ****************************************************


local log = hs.logger.new('mymodule','debug')


-- ****************************************************
-- Searching the right tab
-- ****************************************************


hs.hotkey.bind({"cmd", "alt"}, "x", function()
    chrome_switch_to_tab("Gmail", "gmail.com")
end)
