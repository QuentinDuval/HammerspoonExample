--[[
    Code snipets that can be used in notebooks
]]

require "core.utils";


general_code:register_all{
    {
        text="Notebook",
        subText="Preambule",
        content=string.dedent[[
            import sys
            sys.path.append("..")
                
            %load_ext autoreload
            %autoreload 2
        ]]
    },
}
