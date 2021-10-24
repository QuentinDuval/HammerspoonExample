require "core.copy_watcher";


local watcher = CopyWatcher:new()
watcher:start(9)


hs.hotkey.bind({"cmd", "alt"}, "e", function()
    watcher:search()
end)
