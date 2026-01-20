from gpu.host import DeviceContext
from sys import has_accelerator
from gpu import block_idx, thread_idx

fn print_threads():
   """Print thread IDs."""

   print("Block index: [",
       block_idx.x,
       "]\tThread index: [",
       thread_idx.x,
       "]"
   )

def main():
    @parameter
    if not has_accelerator():
        print("No compatible GPU found")
    else:
        ctx = DeviceContext()
        print("Found GPU:", ctx.name())
