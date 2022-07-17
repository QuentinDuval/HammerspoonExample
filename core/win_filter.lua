--[[
    Helpers to create window filters
]]


function create_window_filter(ap_name)
    local ap_wf = hs.window.filter.new{ap_name}
    ap_wf:setAppFilter(ap_name, {})
    ap_wf:setCurrentSpace(nil)  -- allow all spaces to be watched
    return ap_wf
end


function get_filtered_window_titles(ap_wf)
    local windows = ap_wf:getWindows(hs.window.filter.sortByFocused)
    return hs.fnutils.map(windows, function(window)
        return window:title()
    end)
end