--[[
    Code snipets that can be used in a general fashion
]]

require "core.utils";


general_code:register_all{
    {
        text="argparse: argument parsing",
        content=string.dedent[[
            parser = argparse.ArgumentParser()
            parser.add_argument('-n', '--nodes', type=int)
            parser.add_argument('-g', '--gpus', default=1, type=int, help='number of gpus per node')
            parser.add_argument('-d', '--dependent', action='store_const', const=True, default=False)
            args = parser.parse_args()
        ]]
    },
    {
        text="comment section",
        fct=function()
            local app = hs.application.frontmostApplication()
            local focused = app:focusedWindow()
            local title = ""
            if focused ~= nil then
                title = app:focusedWindow():title()
            end
            if string.find(title, "%.lua") then
                write_lines(string.dedent[[
                    -------------------------------------------------------------------------------
                    -- SECTION
                    -------------------------------------------------------------------------------
                ]])
            else
                write_lines(string.dedent[[
                    """
                    -------------------------------------------------------------------------------
                    SECTION
                    -------------------------------------------------------------------------------
                    """
                ]])
            end
        end
    },
    {
        text="Cuda timer",
        content=[[
            start_event = torch.cuda.Event(enable_timing=True)
            end_event = torch.cuda.Event(enable_timing=True)
            start_event.record()
            
            # Run some things here
            
            end_event.record()
            torch.cuda.synchronize()  # Wait for the events to be recorded!
            elapsed_time_ms = start_event.elapsed_time(end_event)
        ]]
    },
    {
        text="import: torch",
        content=string.dedent[[
            import math
            import numpy as np
            import torch
            import torch.distributed as dist
            import torch.nn as nn
            import torch.optim as optim
            import torch.utils.data as data
            import torch.multiprocessing as mp
        ]]
    },
    {
        text="import: torchvision",
        content=string.dedent[[
            import torchvision
            import torchvision.datasets as datasets
            import torchvision.models as models
            import torchvision.transforms as transforms
        ]]
    },
    {
        text="Pipeline torchvision",
        content=[[
            pipeline = transforms.Compose(
                [
                    transforms.CenterCrop(size=(32, 32)),
                    transforms.RandomHorizontalFlip(),
                    transforms.ToTensor(),
                    transforms.Normalize(
                        mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225], inplace=True
                    ),
                ]
            )
        ]]
    },
    {
        text="Training loop",
        content=[[
            ds = data.TensorDataset(X, Y)
            loader = data.DataLoader(ds, batch_size=128, shuffle=True)
            model = Model()
            optimizer = optim.SGD(model.parameters(), lr=1e-3)
            criterion = nn.MSELoss()
        
            writer = SummaryWriter()
            for epoch in range(10):
                for x, y in loader:
                    y_pred = model(x)
                    loss = criterion(y_pred, y)
                    optimizer.zero_grad()
                    loss.backward()
                    optimizer.step()
                    writer.add_scalar('Loss/train', loss.item(), epoch)
            writer.close()
        ]]
    },
    {
        text="plot",
        content=[[import matplotlib.pyplot as plt]]
    },
}


