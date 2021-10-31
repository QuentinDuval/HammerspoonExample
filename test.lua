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
