--[[
    Spoon that allows to search for the previous
    copy pastes and re-apply them
]]


require "core.expander";


local obj = {}
obj.__index = obj


-- Metadata
obj.name = "Example Spoon"
obj.version = "0.1"
obj.author = "Quentin Duval"
obj.homepage = ""
obj.license = "MIT - https://opensource.org/licenses/MIT"


-- State of the copy watcher
obj._watcher = nil
obj._enabled = true
obj._previous_pastes = {}
obj._max_size = 20


function obj:init()
    -- Automatically called when loading the module
end


function obj:start()
    self._watcher = hs.pasteboard.watcher.new(function(content)
        if not self._enabled then
            return
        end
        if not hs.fnutils.contains(self._previous_pastes, content) then
            local total = #self._previous_pastes
            if total >= self._max_size then
                table.remove(self._previous_pastes, 1)
            end
            table.insert(self._previous_pastes, content)
        end
    end)
    self._watcher:start()
    return self
end


function obj:stop()
    self._watcher:stop()
    return self
end


function obj:max_size(val)
    self._max_size = val
    return self
end


function obj:search()
    local options = hs.fnutils.imap(
        self._previous_pastes,
        function(content)
            return {
                text=content,
                subText="",
                fct=function()
                    self._enabled = false
                    write_lines(content)
                    self._enabled = true
                end
            }
        end
    )
    reverse(options)
    local expander = Expander:new{
        options=options,
        with_sorting=false,
    }
    expander:show()
end


function obj:bindTo(modifiers, key)
    hs.hotkey.bind(modifiers, key, function()
        self:search()
    end)
end


return obj
