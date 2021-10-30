--[[
    Generic object which allows to search for content and run
    the associated function.
]]

require "core.utils";


Expander = {
    options={},
    with_sorting=false,
}


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
        fct=fct,
    })
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


function Expander:show(on_hide)
    local focused = hs.window.focusedWindow()
    local all_choices = {}
    for i, e in ipairs(self.options) do
        table.insert(all_choices, {
            image=hs.image.imageFromName("NSBonjour"),
            -- image=hs.image.imageFromName("NSTouchBarAddDetailTemplate"),
            -- image=hs.image.imageFromName("NSTouchBarPlayTemplate"),
            -- image=hs.image.imageFromName("NSTouchBarGoForwardTemplate"),
            -- image=hs.image.imageFromName("NSTouchBarSlideshowTemplate"),
            text=e.text,
            subText=e.subText,
        })
    end

    --[[
    for i, name in pairs(hs.image.systemImageNames) do
        table.insert(all_choices, {
            image=hs.image.imageFromName(name),
            text=name,
        })
    end
    ]]

    if self.with_sorting then
        table.sort(all_choices, function(l, r) return l.text < r.text end)
    end

    local chooser = hs.chooser.new(function(choice)
        focused:focus();
        if not choice then return end
        self:apply_rule(choice.text)
    end)

    --[[
    t = require("hs.webview.toolbar")
    a = t.new("myConsole", {
            { id = "select1", selectable = true, image = hs.image.imageFromName("NSStatusAvailable") },
            { id = "NSToolbarSpaceItem" },
            { id = "select2", selectable = true, image = hs.image.imageFromName("NSStatusUnavailable") },
            { id = "notShown", default = false, image = hs.image.imageFromName("NSBonjour") },
            { id = "NSToolbarFlexibleSpaceItem" },
            { id = "navGroup", label = "Navigation", groupMembers = { "navLeft", "navRight" }},
            { id = "navLeft", image = hs.image.imageFromName("NSGoLeftTemplate"), allowedAlone = false },
            { id = "navRight", image = hs.image.imageFromName("NSGoRightTemplate"), allowedAlone = false },
            { id = "NSToolbarFlexibleSpaceItem" },
            { id = "cust", label = "customize", fn = function(t, w, i) t:customizePanel() end, image = hs.image.imageFromName("NSAdvanced") }
        }):canCustomize(true)
          :autosaves(true)
          :selectedItem("select2")
          :setCallback(function(...)
                            print("a", inspect(table.pack(...)))
                       end)
    
    chooser:attachedToolbar(a)
    ]]

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

    if on_hide ~= nil then
        chooser:hideCallback(on_hide)
    end

    -- hs.focus()
    hs.dockicon.hide() -- important so that it appears in front in any space
    -- chooser:searchSubText(true)
    chooser:choices(all_choices)
    chooser:rows(5)
    chooser:bgDark(true)
    chooser:show()
end
