
-- *****************************
-- Kind of text expander
-- *****************************

require "core.utils";


-- *****************************
-- Expander object
-- *****************************


Expander = {
    options = {},
    with_sorting = false,
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
        fct=fct}
    )
end

function Expander:apply_rule(input)
    for i, o in ipairs(self.options) do
        if o.text == input then
            if o["line"] ~= nil then
                hs.eventtap.keyStrokes(o.line)
            elseif o["content"] ~= nil then
                write_lines(o.content)
            else
                o.fct()
            end
        end
    end
end

function Expander:without_sort()
    self.with_sorting = false
end

function Expander:show()
    local focused = hs.window.focusedWindow()

    -- Building the list of choices we can search into
    local all_choices = {}
    for i, e in ipairs(self.options) do
        local subText = e.subText
        if subText == nil then
            subText = e.text
        end
        table.insert(all_choices, {text=e.text, subText=subText})
    end

    if self.with_sorting then
        table.sort(all_choices, function(l, r) return l.text < r.text end)
    end

    -- The filtering function that will be used to filter out choices:
    -- * all words separated with ' ' need to be found
    -- * all words prefixed with '-' need to be removed
    -- * the disjunction is supported via '|' (but no parenthesis)
    -- * lower case is used to make it simpler
    function filter_choices(input_choices, q)
        local words = hs.fnutils.split(q, " ")
        local words_to_find = {}
        local words_to_avoid = {}
        for i, word in ipairs(words) do
            if string.sub(word, 1, 1) == "-" then
                -- Find those starting with "-" and move them to words to remove
                if string.len(word) > 1 then
                    table.insert(words_to_avoid, string.sub(word, 2))
                end
            else
                -- Else we need to find those words
                table.insert(words_to_find, word)
            end
        end
        return hs.fnutils.filter(input_choices, function(choice)
            local text = string.lower(choice.text)
            local all_found = hs.fnutils.every(words_to_find, function(word)
                if word == "" then
                    return true
                end
                local disjunction = hs.fnutils.split(word, "|")
                for i, w in ipairs(disjunction) do
                    if string.find(text, string.lower(w)) then
                        return true
                    end
                end
                return false
            end)
            local none_found = hs.fnutils.every(words_to_avoid, function(word)
                return not string.find(text, string.lower(word))
            end)
            return all_found and none_found
        end)
    end

    -- Creating a chooser that will run the selected rule(s)
    local chooser_ref = {}; -- used for self reference
    local chooser = hs.chooser.new(function(choice)
        if focused ~= nil then
            focused:focus();
        end
        local modifiers = hs.eventtap.checkKeyboardModifiers()
        if modifiers.shift then
            -- Multiple command run:
            -- * fetch the commands to run
            local q = chooser_ref.chooser:query()
            local choices = filter_choices(all_choices, q)
            -- * dump them into a file
            hs.eventtap.keyStrokes("cat >run.sh  <<EOL")
            hs.eventtap.keyStroke({}, "return")
            for i, choice in ipairs(choices) do
                self:apply_rule(choice.text)
                hs.eventtap.keyStroke({}, "return")
            end
            hs.eventtap.keyStrokes("EOL")
            hs.eventtap.keyStroke({}, "return")
        else
            -- Single command run
            if not choice then return end
            self:apply_rule(choice.text)
        end
    end)
    chooser_ref.chooser = chooser

    -- Adding a callback for running all matching rules
    chooser:rightClickCallback(function(choice)
        local q = chooser:query()
        local choices = filter_choices(all_choices, q)

        -- We need to hide and cancel the chooser or else it will stay
        -- whereas what we want to do is close it and run all commands
        chooser:hide();
        chooser:cancel();

        focused:focus();
        for i, choice in ipairs(choices) do
            self:apply_rule(choice.text)
        end
    end)

    -- hs.focus()
    hs.dockicon.hide() -- important so that it appears in front in any space
    chooser:choices(all_choices)
    chooser:rows(5)
    -- chooser:bgDark(true)

    -- Custom filtering function, allowing to have several search keywords
    -- each keyword being separated with "+"
    chooser:queryChangedCallback(function(q)
        local choices = filter_choices(all_choices, q)
        chooser:choices(choices)
        return chooser
    end)

    -- Display the window
    chooser:show()
end