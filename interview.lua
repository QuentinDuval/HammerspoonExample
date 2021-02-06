--[[
    Quick shortcuts to enable only when interviewing a candidate:
    
    'cmd-alt-i' to enter and exit the interview mode
    'cmd-alt-x' print the current time (useful to log)
]]

require "core.utils"


k = hs.hotkey.modal.new('cmd-alt', 'i')
k:bind('cmd-alt', 'i', function() k:exit() end)

function k:entered()
    hs.alert('Interview mod: ON')
end

function k:exited()
    hs.alert("Interview mod: OFF") 
end

k:bind('cmd-alt', 'x', function()
    local time = os.date("*t")
    write_lines(("%02d:%02d"):format(time.hour, time.min))
end)
