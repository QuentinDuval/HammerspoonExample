--[[
    Helper to display a text prompt asking for information
]]


function display_text_prompt(title, question)
    local hs_ap = hs.application.find("hammerspoon")
    local ap = hs.application.frontmostApplication()
    hs_ap:activate()
    local ok, content = hs.dialog.textPrompt(title, question)
    ap:activate()
    return content
end
