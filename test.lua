--[[
    Example of using the SQL Lite API:
    http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#sqlite3_open
]]


function open_connection()
    return hs.sqlite3.open('db/foo.db')
end


function with_connection(f)
    local db = open_connection()
    f(db)
    db:close()
end


hs.hotkey.bind({"cmd", "alt"}, "y", function()
    with_connection(function (db)
        local result = db:execute([[
            CREATE TABLE numbers(num1,num2);
            INSERT INTO numbers VALUES(1,11);
            INSERT INTO numbers VALUES(2,22);
            INSERT INTO numbers VALUES(3,33);
        ]]);
        -- hs.alert(result);  -- 0 if successful, 1 if not
    end)
    with_connection(function (db)
        for a in db:nrows('SELECT * FROM numbers') do
            hs.alert(hs.inspect(a))
        end
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
                // alert(document.title);
                console.log(document.title);
                // Last statement will be the return type
                document.title;
            ]], function(result, error)
                hs.alert.show(result)
                hs.alert.show(hs.inspect(error))
            end)
            hs.timer.doAfter(2, function()
                webview:delete()
            end)
        end)
    end)
end)
