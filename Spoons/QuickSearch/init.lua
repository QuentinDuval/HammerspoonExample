--[[
    Allow to quickly search web sites based on
    the content of the selection
]]


require "core.chrome";
require "core.pop_up_menu";
require "core.utils";



local obj = {}
obj.__index = obj


-- Metadata
obj.name = "QuickSearch"
obj.version = "0.1"
obj.author = "Quentin Duval"
obj.homepage = ""
obj.license = "MIT"


-- State of the spoon
obj._enabled = true


function obj:init()
    -- Auomatically called at start-up
end



function search_in_google(content)
    new_chrome_tab_with("http://www.google.fr/search?q=" .. content)
end


function search_in_pydoc(content)
    new_chrome_tab_with("https://docs.python.org/3/search.html?q=" .. content)
end


function search_in_pytorch(content)
    new_chrome_tab_with("https://pytorch.org/docs/stable/search.html?q=" .. content)
end


function search_in_torchvision(content)
    new_chrome_tab_with("https://pytorch.org/vision/stable/search.html?q=" .. content)
end


function search_in_datasets(content)
    new_chrome_tab_with("https://paperswithcode.com/datasets?q=" .. content)
end


function translate_text(content)
    local width = 500
    local height = 400
    local position_point = hs.mouse.getAbsolutePosition()
    local rect = hs.geometry.rect(position_point.x - width / 2, position_point.y - height / 2, width, height)
    local popup_style = hs.webview.windowMasks.utility|hs.webview.windowMasks.HUD|hs.webview.windowMasks.titled|hs.webview.windowMasks.closable
    webview = hs.webview.new(rect)
        :allowTextEntry(true)
        :windowStyle(popup_style)
        :closeOnEscape(true)
        :url("http://www.google.com")
        :bringToFront()
        :show()

    local is_ready = function() return not webview:loading() end
    hs.timer.waitUntil(is_ready, function()
        webview:evaluateJavaScript([[
            for (let element of document.getElementsByName("q")) {
                element.value = "translate to french: ]] .. content .. [[";
            }
            document.querySelector("form").submit();
        ]])
    end)
end


function open_fb_or_slurm_job(content)
    if (content:find("^f") ~= nil) then
        local job_id = string.sub(content, 2, string.len(content))
        new_chrome_tab_right_with("https://www.internalfb.com/intern/fblearner/details/" .. job_id)
    else
        new_chrome_tab_right_with("http://localhost:5000/?#/log/" .. content)
    end
end


function open_diff(content)
    new_chrome_tab_with("https://www.internalfb.com/diff/" .. content)
end


function is_job_id(content)
    local ending_digits_start = content:find("[0-9]*$")
    if ending_digits_start == 1 then
        return true
    elseif ending_digits_start == 2 then
        local starts_with_f = content:find("^f") ~= nil
        return starts_with_f
    else
        return false
    end
end


function is_diff_id(content)
    local ending_digits_start = content:find("[0-9]*$")
    if ending_digits_start == 2 then
        local starts_with_d = content:find("^D") ~= nil
        return starts_with_d
    else
        return false
    end
end


function omni_search(content)
    local url_pattern = "^https?://"
    if (content:find(url_pattern) ~= nil) then
        new_chrome_tab_with(content)
    elseif is_job_id(content) then
        open_fb_or_slurm_job(content)
    elseif is_diff_id(content) then
        open_diff(content)
    else
        search_in_google(content)
    end
end


function on_selection(search_callback)
    return function()
        with_temporary_copy(function()
            local selected_text = copy_selected_text()
            search_callback(selected_text)
        end)
    end
end


function obj:pop_up_search_menu()
    local pop_up = PopUpMenu:new{menu_items={
        { title = "search", fn = on_selection(omni_search) },
        { title = "translate", fn = on_selection(translate_text) },
        { title = "-" },
        -- { title = "search google", fn = on_selection(search_in_google) },
        { title = "search pytorch", fn = on_selection(search_in_pytorch) },
        { title = "search torchvision", fn = on_selection(search_in_torchvision) },
        { title = "search python", fn = on_selection(search_in_pydoc) },
        { title = "-" },
        { title = "search datasets", fn = on_selection(search_in_datasets) },
        { title = "-" },
        { title = "search job", fn = on_selection(open_fb_or_slurm_job) },
        { title = "search diff", fn = on_selection(open_diff)}
    }}
    pop_up:show()
end


function obj:bindTo(modifiers, key)
    hs.hotkey.bind(modifiers, key, function()
        self.pop_up_search_menu()
    end)
end


return obj
