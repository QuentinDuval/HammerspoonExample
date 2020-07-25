-- DO NOT FORGET TO ALLOW HAMMERSPPON TO CONTROL YOUR MAC:
-- https://github.com/Hammerspoon/hammerspoon/issues/1984#issuecomment-481272133

require "core.utils";
require "code_expander";
require "core.pop_up_menu";
require "search";


-- ****************************************************
-- Searching
-- ****************************************************


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


-- *****************************
-- Alternate copy-paste, in order to keep info
-- *****************************

hs.hotkey.bind({"cmd", "alt"}, "c", nil, function()
    with_temporary_copy(function()
        local text = copy_selected_text()
        hs.pasteboard.setContents(text, "Copy2")
    end)
end)


hs.hotkey.bind({"cmd", "alt"}, "v", nil, function()
    write_lines(hs.pasteboard.getContents("Copy2"))
end)


-- *****************************
-- Kind of text expander
-- *****************************


hs.hotkey.bind({"cmd", "alt"}, "z", function()
    text_expander()
end)


-- *****************************
-- Reload the script
-- *****************************


hs.hotkey.bind({"cmd", 'alt'}, 'r', function()
    hs.reload()
end)