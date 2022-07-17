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
    }
}
