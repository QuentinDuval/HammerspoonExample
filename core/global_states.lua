--[[
    Create global variables persisted in DB
]]


function globals_db_connection()
    return hs.sqlite3.open('db/globals.db')
end


function with_globals_db_connection(f)
    local db = globals_db_connection()
    local result = f(db)
    db:close()
    return result
end


function create_tables(db)
    -- db:nrows('SELECT * FROM globals')
    local result = db:execute([[
        CREATE TABLE globals(name,value);
    ]]);
end


function name_exists(db, name)
    local found = false
    for row in db:nrows("select count(*) from globals where name='" .. name .. "'") do
        found = row["count(*)"] > 0
    end
    return found
end


function add_global(name, value)
    with_globals_db_connection(function(db)
        if not name_exists(db, name) then
            local result = db:execute(
                "INSERT INTO globals VALUES('" .. name .. "','" .. value .. "');"
            )
        end
    end)
end


function set_global(name, value)
    return with_globals_db_connection(function(db)
        db:execute("update globals set value='" .. value .. "' where name='" .. name .. "'")
    end)
end


function get_global(name)
    return with_globals_db_connection(function(db)
        for row in db:nrows("select value from globals where name='" .. name .. "'") do
            -- hs.alert.show(hs.inspect(row))
            return row["value"]
        end
        return nil
    end)
end


function list_globals()
    with_globals_db_connection(function(db)
        for row in db:nrows("select * from globals") do
            hs.alert.show(hs.inspect(row))
        end
    end)
end
