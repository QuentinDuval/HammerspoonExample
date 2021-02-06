--[[
    Utilities to search menu-items inside menus
]]


function get_application_menu(ap, name)
    local items = ap:getMenuItems()
    return hs.fnutils.find(items, function(item)
        return item.AXTitle == name
    end)
end


function search_menu(menu_item, search)
    local items = menu_item.AXChildren
    for i, list in ipairs(items) do
        for i, item in ipairs(list) do
            if string.find(item.AXTitle, search) then
                return item
            end
        end
    end
    return nil
end
