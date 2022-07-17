--[[
    PyCharm specific actions (for all PyCharm projects)
]]


pycharm_actions:register_all{
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
