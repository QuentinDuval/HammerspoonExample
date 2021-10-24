--[[
    Quick search by just selecting a string:
    'cmd-alt-s' search the string in google, pytorch doc, python doc
]]


require "core.chrome";
require "core.pop_up_menu";
require "core.utils";


function search_in_pydoc(content)
    new_chrome_tab_with("https://docs.python.org/3/search.html?q=" .. content)
end


function search_in_pytorch(content)
    new_chrome_tab_with("https://pytorch.org/docs/stable/search.html?q=" .. content)
end


function search_in_torchvision(content)
    new_chrome_tab_with("https://pytorch.org/vision/stable/search.html?q=" .. content)
end


function search_in_google(content)
    new_chrome_tab_with("http://www.google.fr/search?q=" .. content) -- search in google
end


function search_paper_with_code(content)
    new_chrome_tab_with("https://paperswithcode.com/search?q_meta=&q_type=&q=" .. content)
end


function omni_search(content)
    if focused_window_name_contains('.py') then
        search_in_pydoc(content)
    else
        search_in_google(content)
    end
end


function on_selected_text(fn)
    return function()
        local content = copy_selected_text()
        fn(content)
    end
end


function pop_up_search_menu()
    local pop_up = PopUpMenu:new{menu_items={
        { title = "search", fn = on_selected_text(omni_search) },
        { title = "-" },
        { title = "google", fn = on_selected_text(search_in_google) },
        { title = "python", fn = on_selected_text(search_in_pydoc) },
        { title = "pytorch", fn = on_selected_text(search_in_pytorch) },
        { title = "torchvision", fn = on_selected_text(search_in_torchvision) },
        { title = "-" },
        { title = "paper with code", fn = on_selected_text(search_paper_with_code) },
    }}
    pop_up:show()
end


hs.hotkey.bind({"cmd", "alt"}, "s", function()
    pop_up_search_menu()
end)
