-- DO NOT FORGET TO ALLOW HAMMERSPPON TO CONTROL YOUR MAC:
-- https://github.com/Hammerspoon/hammerspoon/issues/1984#issuecomment-481272133

require "utils";


-- *****************************
-- Search in the browser
-- *****************************


function search_in_google(content)
    local browser = hs.application.open("Google Chrome", 0.1, true)
    browser:activate()
    hs.eventtap.keyStroke({"cmd"}, "t") -- open a new tab
    hs.eventtap.keyStrokes("http://www.google.fr/search?q=" .. content) -- search in google
    hs.eventtap.keyStroke({}, "return") -- run the search
end


hs.hotkey.bind({"cmd", "alt"}, "s", function()
    local content = copy_selected_text()
    -- Demo on how to do pattern matching
    if content:find('DEF') == 1 then
        hs.alert.show("DEF")
    else
        search_in_google(content)
    end
end)


-- ****************************************************
-- Pop up a menu contextual to the window we are in
-- ****************************************************


function on_search()
    local content = copy_selected_text()
    search_in_google(content)
end

function on_clicked()
    hs.alert.show("Clicked!")
end

function jupyter_standard_imports()
    text = [[
import math 
import matplotplit.pyplot as plt 
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
import torch.utils.data as data]]
    hs.pasteboard.setContents(hs.pasteboard.getContents(), "TEMP")
    hs.pasteboard.writeObjects(text)
    hs.eventtap.keyStroke("cmd", "v")
    hs.pasteboard.setContents(hs.pasteboard.getContents("TEMP"))
end

function pop_up_jupyter_menu()
    pop_up_menu_at_mouse({
        { title = "search", fn = on_search },
        { title = "-" },
        { title = "standard imports", fn = jupyter_standard_imports },
    })
end

function pop_up_default_menu()
    pop_up_menu_at_mouse({
        { title = "search", fn = on_search },
        { title = "-" },
        { title = window_name, fn = on_clicked },
    })
end

hs.hotkey.bind({"cmd", "alt"}, "W", function()
    local window_name = get_window_name()
    if window_name:find('JupyterLab') == 1 then
        pop_up_jupyter_menu()
    else
        pop_up_default_menu()
    end
end)


-- *****************************
-- Reload the script
-- *****************************


hs.hotkey.bind({"cmd", 'alt'}, 'R', function()
    hs.reload()
end)
