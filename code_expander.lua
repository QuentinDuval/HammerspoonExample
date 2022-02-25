--[[
    Shortcurts to quickly write typical code by searching for commong snippets
    "cmd-alt-z" to pop up a search menu with the common code snippets
]]

require "core.expander";


function write_torch_imports()
    text = [[
import math
import numpy as np
import torch
import torch.distributed as dist
import torch.nn as nn
import torch.optim as optim
import torch.utils.data as data
import torch.multiprocessing as mp]]
    write_lines(text)
end


function write_torchvision_imports()
    text = [[import torchvision
import torchvision.datasets as datasets
import torchvision.models as models
import torchvision.transforms as transforms]]
    write_lines(text)
end


function write_training_loop()
    text = [[
    ds = data.TensorDataset(X, Y)
    loader = data.DataLoader(ds, batch_size=500, shuffle=True)
    model = Model(width=500)
    optimizer = optim.SGD(model.parameters(), lr=1e-3)
    criterion = nn.MSELoss()

    writer = SummaryWriter()
    for epoch in range(10):
        episode_loss = 0.
        for x, y in loader:
            y_pred = model(x)
            loss = criterion(y_pred, y)
            episode_loss += loss.item()
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
        writer.add_scalar('Loss/train', episode_loss, epoch)
    writer.close()]]
    write_lines(text)
end


function write_simple_model()
    text=[[
class Model(nn.Module):
    def __init__(self, input_size: int, output_size: int):
        super().__init__()
        self.fc = nn.Linear(input_size, output_size)
        self.relu = nn.ReLU()
    
    def forward(self, xs):
        return self.fc(xs)]]
    write_lines(text)
end


function write_argument_parsing()
    text=[[
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--nodes', type=int)
    parser.add_argument('-g', '--gpus', default=1, type=int, help='number of gpus per node')
    parser.add_argument('-d', '--dependent', action='store_const', const=True, default=False)
    args = parser.parse_args()]]
    write_lines(text)
end


function write_notebook_preambule()
    text=[[import sys
sys.path.append("..")
    
%load_ext autoreload
%autoreload 2]]
    write_lines(text)
end


function write_script_preambule()
    text=[[import os
import sys
import inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)]]
    write_lines(text)
end


function write_launch_json()
    text = [[{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Current File",
            "type": "python",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal",
            "justMyCode": false,
            "env": {
                "PYTHONPATH": "/private/home/qduval/project/python_test/:$PYTHONPATH"
            }
        }
    ]
    }]]
    write_lines(text)
end


function write_timer_code()
    write_lines([[start = time.perf_counter()
end = time.perf_counter()
print(end - start)
]])
end


function write_cuda_timer_code()
    text=[[start_event = torch.cuda.Event(enable_timing=True)
    end_event = torch.cuda.Event(enable_timing=True)
    start_event.record()
    
    # Run some things here
    
    end_event.record()
    torch.cuda.synchronize()  # Wait for the events to be recorded!
    elapsed_time_ms = start_event.elapsed_time(end_event)]]
    write_lines(text)
end


function write_pil_code()
    write_lines([[pic = PIL.Image.open(first_path)
    pix = np.array(pic.getdata()).reshape(pic.size[0], pic.size[1], 3)
    PIL.Image.fromarray(pix)]])
end


function write_section_comment()
    write_lines([[
"""
-------------------------------------------------------------------------------
SECTION NAME
-------------------------------------------------------------------------------
"""]])
end


function write_get_memory()
    text = "sys.getsizeof(object)"
    write_lines(text)
end


function write_torchvision_pipeline()
    text = [[pipeline = transforms.Compose(
        [
            transforms.CenterCrop(size=(32, 32)),
            transforms.RandomHorizontalFlip(),
            transforms.ToTensor(),
            transforms.Normalize(
                mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225], inplace=True
            ),
        ]
    )]]
    write_lines(text)
end


function write_ignore_warning()
    text = [[with warnings.catch_warnings():
    warnings.simplefilter("ignore")]]
    write_lines(text)
end


function write_to_pil_image()
    text = [[def to_image(tensor, lo=-1, hi=1.):
    if tensor.ndim == 4:
        tensor = tensor.squeeze(0)
    tensor = tensor.permute((1, 2, 0))
    array = tensor.detach().numpy()
    lo = lo or array.min()
    hi = hi or array.max()
    array = (array - lo) / (hi - lo)
    array = np.uint8(255 * array)
    return Image.fromarray(array)]]
    write_lines(text)
end


-- *****************************
-- The code expander
-- *****************************


function text_expander()
    local expander = Expander:new{ options={
        {text="args", subText="argument parsing", fct=write_argument_parsing},
        {text="launch.json", subText="launch JSON configuration", fct=write_launch_json},
        {text="memory of", subText="get memory size of python object", fct=write_get_memory},
        {text="model", subText="torch model", fct=write_simple_model},
        {text="notebook", subText="notebook preambule", fct=write_notebook_preambule},
        {text="pipeline", subText="torchvision pipeline", fct=write_torchvision_pipeline},
        {text="pil", subText="creation of a pil image", fct=write_pil_code},
        {text="plot", subText="plot imports", content=[[import matplotlib.pyplot as plt]]},
        {text="section", subText="section in python", fct=write_section_comment},
        {text="script", subText="script preambule", fct=write_script_preambule},
        {text="timer", subText="timing the speed of function", fct=write_timer_code},
        {text="timer cuda", subText="timing speed of neural nets", fct=write_cuda_timer_code},
        {text="train", subText="training loop", fct=write_training_loop},
        {text="torch", subText="torch imports", fct=write_torch_imports},
        {text="to_image", subText="tensor to PIL image", fct=write_to_pil_image},
        {text="torchvision", subText="torchvision imports", fct=write_torchvision_imports},
        {text="warnings", subText="ignore warnings", fct=write_ignore_warning},
        {text="quotes", subText="code quotes", content=[[```
```]]},
    }}
    expander:show()
end


hs.hotkey.bind({"cmd", "alt"}, "z", function()
    text_expander()
end)
