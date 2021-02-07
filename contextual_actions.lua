--[[[
    Actions specific for each application
]]

require "core.chrome";
require "core.expander";
require "core.pycharm";


local log = hs.logger.new('contextual','debug')


-- TODO: add all existing tabs inside it


function show_pycharm_actions()
    expander = Expander:new{ options={
        {
            text="Open SSH session",
            subText="Open SSH session",
            fct=function()
                pycharm_open_new_ssh_terminal()
            end
        },
        {
            text="Interpreter",
            subText="Configure interpreter",
            fct=function()
                pycharm_interpreter()
            end
        }
    }}
    expander:show()
end


function show_contextual_actions()
    local ap = hs.application.frontmostApplication()
    local ap_name = ap:name()
    if string.find(ap_name, "PyCharm") then
        show_pycharm_actions()
    end    
end


hs.hotkey.bind({"cmd", "alt"}, "a", function()
    show_contextual_actions()
end)
