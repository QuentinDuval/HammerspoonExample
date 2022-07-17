--[[[
    Actions specific for each application
]]

require "project.contexts";
require "project.registry";

require "project.code.init";
require "project.pycharm.init";
require "project.vscode.init";


hs.hotkey.bind({"cmd", "alt"}, "q", function()
    Action:pop_up("action")
end)


hs.hotkey.bind({"cmd", "alt"}, "w", function()
    Action:pop_up("code")
end)
