--[[
    Quick search by just selecting a string:
    'cmd-alt-s' search the string in google, pytorch doc, python doc
]]


require "core.chrome";
require "core.utils";


function search_in_pydoc(content)
    new_chrome_tab_with("https://docs.python.org/3/search.html?q=" .. content)
end


function search_in_pytorch(content)
    new_chrome_tab_with("https://pytorch.org/docs/stable/search.html?q=" .. content)
end


function search_in_google(content)
    new_chrome_tab_with("http://www.google.fr/search?q=" .. content) -- search in google
end


function omni_search(content)
    if focused_window_name_contains('.py') then
        search_in_pydoc(content)
    else
        search_in_google(content)
    end
end


function on_omni_search()
    local content = copy_selected_text()
    omni_search(content)
end


function on_google_search()
    local content = copy_selected_text()
    search_in_google(content)
end


function on_pytorch_search()
    local content = copy_selected_text()
    search_in_pytorch(content)
end


function on_python_search()
    local content = copy_selected_text()
    search_in_pydoc(content)
end


function pop_up_search_menu()
    local pop_up = PopUpMenu:new{menu_items={
        { title = "search", fn = on_omni_search },
        { title = "-" },
        { title = "search google", fn = on_google_search },
        { title = "search pytorch", fn = on_pytorch_search },
        { title = "search python", fn = on_python_search },
    }}
    pop_up:show()
end


hs.hotkey.bind({"cmd", "alt"}, "s", function()
    pop_up_search_menu()
end)
