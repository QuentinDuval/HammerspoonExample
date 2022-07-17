--[[
    Command line helpers to deal with file system
]]


function mkdir(dir_name)
    hs.eventtap.keyStrokes("mkdir -p " .. dir_name)
    hs.eventtap.keyStroke({}, "return")
end


function cd(dir_name)
    hs.eventtap.keyStrokes("cd " .. dir_name)
    hs.eventtap.keyStroke({}, "return")
end


function mkcd(dir_name)
    mkdir(dir_name)
    cd(dir_name)
end
