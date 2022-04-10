function pop_web_example()
    -- arguments to provide to the function
    local label = "Enter input:"
    local default = ""
    local wrapped_callback = function(name, input, view)
        print(name)
        print(input)
        view:delete()
    end

    -- Register a callback with a name
    local uccName = "prompter" .. hs.host.uuid():gsub("-","")    
    local ucc = hs.webview.usercontent.new(uccName):setCallback(function(input)
        print(hs.inspect(input))
        wrapped_callback(input.name, input.body, input.webView)
    end)

    -- Code for the page to show
    local frame = hs.geometry.rect(0, 0, 500, 400)
    local popup_style = hs.webview.windowMasks.utility|hs.webview.windowMasks.HUD|hs.webview.windowMasks.titled|hs.webview.windowMasks.closable
    local view = hs.webview.new(frame, { developerExtrasEnabled = true }, ucc)
    view:allowTextEntry(true):windowStyle(popup_style):closeOnEscape(true)
    local html_content = io.read_file("core/rsrc/form.html")
    html_content = string.gsub(html_content, "uccName", uccName)
    view:html(html_content)

    view:bringToFront():show()
end


function pop_web_form(field_names, callback)
    --[[
        Takes a lit of field names and a callback
        and pop up a web form where we can set those
        values and close the form
    ]]

    -- arguments to provide to the function
    local label = "Enter input:"
    local default = ""
    local wrapped_callback = function(name, input, view)
        print(name)
        print(input)
        view:delete()
    end

    -- Register a callback with a name
    local uccName = "prompter" .. hs.host.uuid():gsub("-","")    
    local ucc = hs.webview.usercontent.new(uccName):setCallback(function(input)
        -- print(hs.inspect(input))
        wrapped_callback(input.name, input.body, input.webView)
    end)

    -- Code for the page to show
    local frame = hs.geometry.rect(0, 0, 500, 400)
    local popup_style = hs.webview.windowMasks.utility|hs.webview.windowMasks.HUD|hs.webview.windowMasks.titled|hs.webview.windowMasks.closable
    local view = hs.webview.new(frame, { developerExtrasEnabled = true }, ucc)
    view:allowTextEntry(true):windowStyle(popup_style):closeOnEscape(true)
    view:html([[
        <html>
        <body>

        <h1>The Window Object</h1>
        <h2>The prompt() Method</h2>

        <p>Click the button to demonstrate the prompt box.</p>

        <button onclick="myFunction()">Try it</button>

        <p id="demo"></p>

        <script>
        function myFunction() {
            let person = prompt("Please enter your name", "Harry Potter");
            if (person != null) {
                document.getElementById("demo").innerHTML =
                "Hello " + person + "! How are you today?";
            }
        }
        </script>

        </body>
        </html>
    ]])

    view:bringToFront():show()

end