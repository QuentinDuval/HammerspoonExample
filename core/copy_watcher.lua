--[[
    Watch for copy in the clip board and allows to search
    for previous copies
]]


require "core.expander";
require "core.utils";


CopyWatcher = {
    watcher = nil,
    enabled = true,
    previous_pastes = {},
}


function CopyWatcher:new(m)
    m = m or {}
    setmetatable(m, self)
    self.__index = self
    return m
end


function CopyWatcher:start(max_size)
    self.watcher = hs.pasteboard.watcher.new(function(content)
        if not self.enabled then
            return
        end

        if not hs.fnutils.contains(self.previous_pastes, content) then
            local total = #self.previous_pastes
            if total >= max_size then
                table.remove(self.previous_pastes, 1)
            end
            table.insert(self.previous_pastes, content)
        end
    end)
    self.watcher:start()
end


function CopyWatcher:stop()
    self.watcher:stop()
end


function CopyWatcher:search()
    local options = hs.fnutils.imap(
        self.previous_pastes,
        function(content)
            return {
                text=content,
                subText="",
                fct=function()
                    self.enabled = false
                    write_lines(content)
                    self.enabled = true
                end
            }
        end
    )
    local expander = Expander:new{options=options}
    expander:show()
end

