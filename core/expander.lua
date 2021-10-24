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
    local rule = hs.fnutils.find(self.options, function(o)
        return o.text == input
    end)
    if rule ~= nil then
        if rule.fct ~= nil then
            rule.fct()
        else
            write_lines(rule.content)
        end
    end
end


function Expander:show()
    local focused = hs.window.focusedWindow()
    local all_choices = {}
    for i, e in ipairs(self.options) do
        table.insert(all_choices, {text=e.text, subText=e.subText})
    end
    table.sort(all_choices, function(l, r) return l.text < r.text end)

    local chooser = hs.chooser.new(function(choice)
        focused:focus();
        if not choice then return end
        self:apply_rule(choice.text)
    end)

    -- Searching for all query parts where query
    -- parts are separated with the '+' sign
    chooser:queryChangedCallback(function(query)
        local query_parts = hs.fnutils.split(query, "+")
        local choices = hs.fnutils.ifilter(
            all_choices,
            function(choice)
                return hs.fnutils.every(
                    query_parts,
                    function(query_part)
                        return string.match(choice.text, query_part)
                    end
                )
            end
        )
        chooser:choices(choices)
    end)

    -- hs.focus()
    hs.dockicon.hide() -- important so that it appears in front in any space
    -- chooser:searchSubText(true)
    chooser:choices(all_choices)
    chooser:rows(5)
    chooser:bgDark(true)
    chooser:show()
end
