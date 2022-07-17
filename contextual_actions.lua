--[[[
    Actions specific for each application
]]

require "core.chrome";
require "core.expander";
require "core.pycharm";


local log = hs.logger.new('contextual','debug')


-- TODO: add all existing tabs inside it


function get_pycharm_actions()
    return {
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
    }
end


function get_vscode_actions()
    return {
        {
            text="Example actions",
            fct=function() hs.alert("example") end
        }
    }
end


function show_contextual_actions()
    local ap = hs.application.frontmostApplication()
    local ap_name = ap:name()

    local actions = {}
    if string.find(ap_name, "PyCharm") then
        actions = hs.fnutils.concat(actions, get_pycharm_actions())
    elseif string.find(ap_name, "Code") then
        actions = hs.fnutils.concat(actions, get_vscode_actions())
    end    

    expander = Expander:new{ options=actions }
    expander:show()
end


hs.hotkey.bind({"cmd", "alt"}, "q", function()
    show_contextual_actions()
end)
