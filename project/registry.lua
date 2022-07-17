--[[
    Registry of user actions
]]


require "core.expander";


Action = {
    registry = {},
    use_context = true,
}


function Action:with_contexts(context_list)
    local sub_registers = {}
    if context_list ~= nil then
        for i, context in ipairs(context_list) do
            self.registry[context] = self.registry[context] or {}
            table.insert(sub_registers, self.registry[context])
        end
    end
    return ActionContext:new{sub_registers=sub_registers}
end


function Action:with_context(context)
    self.registry[context] = self.registry[context] or {}
    return ActionContext:new{sub_registers={self.registry[context]}}
end


function Action:toggle_use_context()
    self.use_context = not self.use_context
    if self.use_context then
        hs.alert.show("Enabled: contextual commands")
    else
        hs.alert.show("Disabled: contextual commands")
    end
end


function Action:pop_up(action_type)
    -- Capture application name and window name
    local ap = hs.application.frontmostApplication()
    local ap_name = ap:name()
    local focused_window = ap:focusedWindow()
    local window_name = ""
    if focused_window ~= nil then
        window_name = focused_window:title()
    end
    print("Application name: " .. ap_name)
    print("Window name: " .. window_name)
    
    -- Loop through all contextx and their associated actions
    local selected_actions = {}
    for context, actions in pairs(self.registry) do
        local add_actions = true

        -- Check that that the actions have the right type
        if context.action_type ~= nil then
            if context.action_type ~= action_type then
                add_actions = false
            end
        end

        -- Use context to filter out some other contextx based
        -- on application name and window name
        if self.use_context then
            if context.application ~= nil then
                add_actions = add_actions and string.find(ap_name, context.application)
            end
            if context.title ~= nil and window_name ~= "" then
                add_actions = add_actions and string.find(window_name, context.title)
            end
        end

        -- If actions are selected, add them all to the list
        if add_actions then
            selected_actions = hs.fnutils.concat(selected_actions, actions)
        end
    end

    -- Display an expander with all the selected actions
    expander = Expander:new{options=selected_actions}
    expander:show()
end


ActionContext = {}


function ActionContext:new(m)
    m = m or { sub_registers={} }
    setmetatable(m, self)
    self.__index = self
    return m
end


function ActionContext:register(action)
    for i, sub_register in ipairs(self.sub_registers) do
        table.insert(sub_register, action)
    end
end


function ActionContext:register_all(actions)
    for i, sub_register in ipairs(self.sub_registers) do
        for i, action in ipairs(actions) do
            table.insert(sub_register, action)
        end
    end
end
