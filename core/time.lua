--[[
    Time utils
]]


function get_date_time()
    local time = os.date("*t")
    return ("%04d-%02d-%02d-%02d:%02d:%02d"):format(time.year, time.month, time.day, time.hour, time.min, time.sec)
end