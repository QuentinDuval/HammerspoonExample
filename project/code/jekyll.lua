--[[
    Commands used to help deal with Jekyll blogs
]]


jekyll_lua_code:register_all{
    {
        text="jekyll: post preambule",
        content=string.dedent[[
            ---
            layout: post
            title: ""
            description: ""
            excerpt: "Appears in preview"
            categories: [functional-programming]
            tags: [Functional-Programming, Haskell]
            use_math: true
            ---
        ]]
    },
    {
        text="Link",
        content=[[({% link _posts/2017-07-06-hexagonal-architecture-free-monad.md %})]]
    },
    {
        text="Code block",
        fct=function()
            local raw_copied_text = string.strip(get_selected_text())
            local content = string.dedent[[
                ```haskell
                %s
                ```
            ]]
            content = string.format(content, raw_copied_text)
            write_lines(content)
        end
    }
}
