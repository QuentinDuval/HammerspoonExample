--[[
    Contexts used for the declaring the cations
]]


require "project.registry";


general_code = Action:with_context(
    {application=nil, title=nil, action_type="code"}
)

jekyll_lua_code = Action:with_context(
    {application="Code", title="github.io", action_type="code"}
)

general_actions = Action:with_context(
    {application=nil, title=nil, action_type="action"}
)

pycharm_actions = Action:with_contexts({
    { application="PyCharm", title=nil, action_type="action"}
})

vs_code_lua_actions = Action:with_context(
    {application="Code", title="lua", action_type="action"}
)

terminal_actions = Action:with_contexts{
    {application="Terminal", title=nil, action_type="action"},
    {application="iTerm2", title=nil, action_type="action"},
}
