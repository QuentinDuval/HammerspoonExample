-- *****************************
-- Kind of pop up menu
-- *****************************

require "core.utils";


-- *****************************
-- Pop-up menu object
-- *****************************


PopUpMenu = { menu_items={} }

function PopUpMenu:new(m)
    m = m or {}
    setmetatable(m, self)
    self.__index = self
    return m
end

function PopUpMenu:separator()
    table.insert(self.menu_items, {"-"})
end

function PopUpMenu:add_item(title, fct)
    table.insert(self.menu_items, { title = title, fn = fct })
end

function PopUpMenu:show()
    local menubar = hs.menubar.new()
    menubar:setMenu(self.menu_items)
    local position_point = hs.mouse.getAbsolutePosition()
    menubar:popupMenu(position_point)
end
