function pop_web_example()
    -- arguments to provide to the function
    local label = "Enter input:"
    local default = ""
    local wrapped_callback = function(name, input, view)
        -- Print name of the handler
        print(name)
        -- Print content of the answer
        print(hs.inspect(input))
        -- To close the view
        view:delete()
    end

    -- Register a callback with a name
    local uccName = "prompter" .. hs.host.uuid():gsub("-","")    
    local ucc = hs.webview.usercontent.new(uccName):setCallback(function(input)
        -- print(hs.inspect(input))
        wrapped_callback(input.name, input.body, input.webView)
    end)

    -- Code for the page to show
    local position_point = hs.mouse.getAbsolutePosition()
    local frame = hs.geometry.rect(position_point.x, position_point.y, 300, 200)
    local popup_style = hs.webview.windowMasks.utility|hs.webview.windowMasks.HUD|hs.webview.windowMasks.titled|hs.webview.windowMasks.closable
    local view = hs.webview.new(frame, { developerExtrasEnabled = true }, ucc)
    view:allowTextEntry(true):windowStyle(popup_style):closeOnEscape(true)
    local html_content = io.read_file("core/rsrc/form.html")
    html_content = string.gsub(html_content, "uccName", uccName)
    view:html(html_content)
    view:bringToFront():show()
end
