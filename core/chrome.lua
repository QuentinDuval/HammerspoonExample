
--[[
    Module to interact with Chrome
]]


function new_chrome_tab_with(address)
    local browser = hs.application.open("Google Chrome", 0.1, true)
    browser:activate()
    hs.eventtap.keyStroke({"cmd"}, "t") -- open a new tab
    hs.eventtap.keyStrokes(address) -- search in google
    hs.eventtap.keyStroke({}, "return") -- validate auto completion
    hs.eventtap.keyStroke({}, "return") -- run the search
end
