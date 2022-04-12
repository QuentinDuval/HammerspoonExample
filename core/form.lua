function pop_web_example(options)
    -- Default values for the options
    local labels = options.labels
    local on_success = options.on_success
    local width = options.width or 300
    local height = options.height or (100 + 40 * #labels)
    local position = options.position or hs.mouse.getAbsolutePosition()
    local stay_open = options.stay_open or false

    -- TODO: Arguments to provide to the function
    local wrapped_callback = function(name, input, view)
        on_success(input)
        if not stay_open then
            view:delete()
        end
    end

    -- Register a callback with a name
    local uccName = "prompter" .. hs.host.uuid():gsub("-","")    
    local ucc = hs.webview.usercontent.new(uccName):setCallback(function(input)
        wrapped_callback(input.name, input.body, input.webView)
    end)

    -- Create the pop up
    local frame = hs.geometry.rect(position.x, position.y, width, height)
    local popup_style = hs.webview.windowMasks.utility|hs.webview.windowMasks.HUD|hs.webview.windowMasks.titled|hs.webview.windowMasks.closable
    local view = hs.webview.new(frame, { developerExtrasEnabled = true }, ucc)
    view:allowTextEntry(true):windowStyle(popup_style):closeOnEscape(true)
    
    -- Load the HTML form and place the UCC handler in it
    local html_content = io.read_file("core/rsrc/form.html")
    html_content = string.gsub(html_content, "uccName", uccName)

    -- Then instantiate as many fields as needed
    local fields = "";
    for i, label in ipairs(labels) do
        fields = fields .. [[
            <span>]] .. label .. [[</span>
            <input name="field" placeholder="Enter text here..."></input>
            <p></p>
        ]]
    end
    local placeholder = "<span>PLACEHOLDER</span>"
    html_content = string.gsub(html_content, placeholder, fields)

    -- Now pop up the web page
    view:html(html_content)
    view:bringToFront():show()
end
