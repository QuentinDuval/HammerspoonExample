--[[
    Quickly find your tabs / apps on multiple desktop and focus on them
    "cmd-alt-x" to search for your favorite tab or application
]]

require "core.chrome";
require "core.expander";
require "core.pycharm";


local log = hs.logger.new('app_launcher','debug')


-- TODO: add all existing tabs inside it


function search_ap_or_tab()
    expander = Expander:new{ options={
        {
            text="gmail",
            subText="open gmail",
            fct=function()
                chrome_switch_to_tab("Gmail", "gmail.com")
            end
        },
        {
            text="jupyter",
            subText="open jupyter lab notebook",
            fct=function()
                chrome_switch_to_tab("Jupyter")
            end
        },
        {
            text="tensorboard",
            subText="open tensorboard tab",
            fct=function()
                chrome_switch_to_tab("TensorBoard")
            end
        },
    }}
    local pycharm_windows = get_pycharm_windows()
    hs.fnutils.each(pycharm_windows, function(window_name)
        expander:add_choice(window_name, window_name, function()
            switch_to_pycharm_window(window_name)
        end)
    end)
    expander:show()
end


hs.hotkey.bind({"cmd", "alt"}, "x", function()
    search_ap_or_tab()
end)
