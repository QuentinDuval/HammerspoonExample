--[[
    Generic object which allows to search for content and run
    the associated function.
]]

require "core.utils";


Expander = { options={} }

function Expander:new(e)
    e = e or {}
    setmetatable(e, self)
    self.__index = self
    return e
end

function Expander:add_choice(text, subText, fct)
    table.insert(self.options, {
        text=text,
        subText=subText,
        fct=fct})
end

function Expander:apply_rule(input)
    for i, o in ipairs(self.options) do
        if o.text == input then
            o.fct()
        end
    end
end


function Expander:show()
    local focused = hs.window.focusedWindow()
    local choices = {}
    for i, e in ipairs(self.options) do
        table.insert(choices, {text=e.text, subText=e.subText})
    end
    table.sort(choices, function(l, r) return l.text < r.text end)

    local chooser = hs.chooser.new(function(choice)
        focused:focus();
        if not choice then return end
        self:apply_rule(choice.text)
    end)

    -- hs.focus()
    hs.dockicon.hide() -- important so that it appears in front in any space
    -- chooser:searchSubText(true)
    chooser:choices(choices)
    chooser:rows(5)
    chooser:bgDark(true)
    chooser:show()
end
