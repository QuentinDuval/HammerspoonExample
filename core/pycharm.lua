--[[
    Utilities to interact with PyCharm
]]

require "core.menu_search";
require "core.utils";
require "core.win_filter";


local log = hs.logger.new('core.pycharm','debug')


-- Show tabs with all windows in the PyCharm title bar
-- hs.tabs.enableForApp("PyCharm")


-- Define a window filter that watches the PyCharm windows
-- (because hs.application:allWindows() only return windows in the current space)
-- It does not work perfectly either: the filter usually retains only the last one
local pycharm_wf = create_window_filter("PyCharm")


function get_pycharm_windows()
    return get_filtered_window_titles(pycharm_wf)
end


function get_project_from_window_name(window_name)
    return hs.fnutils.split(window_name, " - ")[1]
end


function switch_to_pycharm_window(pattern)
    local ap = hs.application.find("PyCharm")
    if (ap) then
        ap:activate()
        local title = get_project_from_window_name(pattern)
        ap:selectMenuItem({"Window", title})
        --[[
        local windows = pycharm_wf:getWindows(hs.window.filter.sortByFocused)
        local window = hs.fnutils.find(windows, function(window)
            return window:title() == pattern
        end)
        window:focus()
        ]]
    else
        hs.alert("No PyCharm window found")
    end
end


function pycharm_open_new_ssh_terminal()
    local ap = hs.application.find("PyCharm")
    local success = ap:selectMenuItem({"Tools", "Start SSH session..."})
    if (success) then
        hs.timer.doAfter(0.5, function()
            hs.eventtap.keyStroke({}, "down")
            hs.eventtap.keyStroke({}, "down")
            hs.eventtap.keyStroke({}, "return")
        end)
    end
end


-------------------------------------------------------------------------------
-- Pycharm conda navigation
-------------------------------------------------------------------------------

PyCharmTerminal = {
    conda_registry = {}
}

function PyCharmTerminal:register_conda_env(project_name, conda_name)
    self.conda_registry[project_name] = conda_name
end

function PyCharmTerminal:get_conda_env_for(project_name)
    return self.conda_registry[project_name]
end

function pycharm_terminal_go_to_project_folder()
    local ap = hs.application.find("PyCharm")
    local window_name = ap:focusedWindow():title()
    local proj_name = get_project_from_window_name(window_name)
    hs.eventtap.keyStrokes("cd ~/project/" .. proj_name) 
    hs.eventtap.keyStroke({}, "return")
    conda_env_name = PyCharmTerminal:get_conda_env_for(proj_name)
    if conda_env_name ~= nil then
        hs.eventtap.keyStrokes("conda activate " .. conda_env_name)
        hs.eventtap.keyStroke({}, "return")
    else
        hs.eventtap.keyStrokes("conda_activate")
        hs.eventtap.keyStroke({}, "return")
    end
end

-------------------------------------------------------------------------------

function pycharm_terminal_go_to_test_folder()
    local ap = hs.application.find("PyCharm")
    local window_name = ap:focusedWindow():title()
    local proj_name = get_project_from_window_name(window_name)
    hs.eventtap.keyStrokes("cd ~/project/" .. proj_name) 
    hs.eventtap.keyStroke({}, "return")
    hs.eventtap.keyStrokes("cd tests") 
    hs.eventtap.keyStroke({}, "return")
end


function pycharm_deploy_code()
    local ap = hs.application.find("PyCharm")
    ap:selectMenuItem({"Tools", "Deployment", "Upload to devfair"})
end


function pycharm_interpreter()
    local ap = hs.application.find("PyCharm")
    local success = ap:selectMenuItem("Preferences...")
    if (success) then
        hs.timer.doAfter(0.5, function()
            hs.eventtap.keyStrokes("Interpreter")
        end)
    end
end


function pycharm_git_push()
    hs.eventtap.keyStroke({"shift-cmd"}, "k")
end


function pycharm_upload_diff()
    -- TODO
    -- might be a good use case for:
    -- https://www.hammerspoon.org/docs/hs.pathwatcher.html
end
