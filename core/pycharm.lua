--[[
    Utilities to interact with PyCharm
]]


local log = hs.logger.new('core.pycharm','debug')


function get_pycharm_windows()
    local ap = hs.application.find("PyCharm")
    local windows = ap:allWindows()
    return hs.fnutils.map(windows, function(window)
        return window:title()
    end)
end


function switch_to_pycharm_window(pattern)
    local ap = hs.application.find("PyCharm")
    local window = ap:findWindow(pattern)
    window:focus()
end


function open_new_ssh_terminal()
    -- TODO
end

