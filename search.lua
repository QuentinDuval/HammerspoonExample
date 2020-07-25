require "core.utils";


-- *****************************
-- Search in the browser
-- *****************************


function new_google_tab_with(address)
    local browser = hs.application.open("Google Chrome", 0.1, true)
    browser:activate()
    hs.eventtap.keyStroke({"cmd"}, "t") -- open a new tab
    hs.eventtap.keyStrokes(address) -- search in google
    hs.eventtap.keyStroke({}, "return") -- validate auto completion
    hs.eventtap.keyStroke({}, "return") -- run the search
end


function search_in_pydoc(content)
    new_google_tab_with("https://docs.python.org/3/search.html?q=" .. content)
end


function search_in_pytorch(content)
    new_google_tab_with("https://pytorch.org/docs/stable/search.html?q=" .. content)
end


function search_in_google(content)
    new_google_tab_with("http://www.google.fr/search?q=" .. content) -- search in google
end


function omni_search(content)
    if focused_window_name_contains('.py') then
        search_in_pydoc(content)
    else
        search_in_google(content)
    end
end