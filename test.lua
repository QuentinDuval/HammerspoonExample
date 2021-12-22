--[[
    Example of using the SQL Lite API:
    http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#sqlite3_open
]]


require "core.global_states";


hs.hotkey.bind({"cmd", "alt"}, "y", function()
    local first_name = PersitentGlobal:new("first_name", "quentin")
    local last_name = PersitentGlobal:new("last_name", "duval")
    hs.alert.show(first_name:get())
    first_name:set("Quentin")
    hs.alert.show(first_name:get())
    PersitentGlobal.list()
end)


hs.hotkey.bind({"cmd", "alt"}, "p", function()
    hs.http.asyncGet("http://0.0.0.0:5000/stream", nil, function(code, body, headers)
        -- This will wait for the complete answer, no support for streaming
        hs.alert.show(code)
        hs.alert.show(hs.inspect(body))
    end)
end)


hs.hotkey.bind({"cmd", "alt"}, "u", function()
    
    -- Example on how to visualise a brower window,
    -- find an element in the DOM and them enter text
    -- and do the research

    local rect = hs.geometry.rect(0, 0, 500, 400)
    local popup_style = hs.webview.windowMasks.utility|hs.webview.windowMasks.HUD|hs.webview.windowMasks.titled|hs.webview.windowMasks.closable

    webview = hs.webview.new(rect)
        :allowTextEntry(true)
        :windowStyle(popup_style)
        :closeOnEscape(true)

    webview:url("http://www.google.com")
      :bringToFront()
      :show()
    
    hs.timer.doAfter(1, function()
        webview:evaluateJavaScript([[
            for (let element of document.getElementsByName("q")) {
                element.value = "example query";
            }
            /*
            // There is not button in the case of google search, it is a form
            const buttons = document.getElementsByName("btnI");
            for (let button of buttons) {
                alert(button);
                button.submit();
            }
            */
            document.querySelector("form").submit();
        ]])
        -- Show that we can get the second screen after as well
        hs.timer.doAfter(2, function()
            webview:evaluateJavaScript([[
                // Get the results returned by Google Search
                let results = [];
                for (let elem of document.getElementsByTagName("h3")) {
                    results.push(elem.textContent);
                }
                // Last statement will be the return type
                // document.title;
                results;
            ]], function(result, error)
                hs.alert.show(hs.inspect(result))
                -- hs.alert.show(hs.inspect(error))
                webview:delete()
            end)
            --[[
            hs.timer.doAfter(2, function()
                webview:delete()
            end)
            ]]
        end)
    end)
end)


hs.hotkey.bind({"cmd", "alt"}, "m", function()
    -- arguments to provide to the function
    local label = "Enter input:"
    local default = ""
    local callback = function(name, input, view)
        print(name)
        print(input)
        view:delete()
    end

    -- Register a callback with a name
    local uccName = "prompter" .. hs.host.uuid():gsub("-","")    
    local ucc = hs.webview.usercontent.new(uccName):setCallback(function(input)
        -- print(hs.inspect(input))
        callback(input.name, input.body, input.webView)
    end)

    -- Code for the page to show
    local view = hs.webview.new(frame, { developerExtrasEnabled = true }, ucc):html([[
        <script type="text/javascript">
        var textMsg = window.prompt("]]..label..[[", "]]..default..[[") ;
        try {
            webkit.messageHandlers.]]..uccName..[[.postMessage(textMsg) ;
        } catch(err) {
            console.log('Controller ]]..uccName..[[ does not exist');
            console.log(err)
        }
        </script>
    ]]):show()

end)