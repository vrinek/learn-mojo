from sys import has_accelerator, has_apple_gpu_accelerator

from gpu.host import DeviceContext
from gpu import block_idx, thread_idx

fn print_threads():
   """Print thread IDs."""

   print("Block index: [",
       block_idx.x, block_idx.y, block_idx.z,
       "]\tThread index: [",
       thread_idx.x, thread_idx.y, thread_idx.z,
       "]"
   )

def main():
    @parameter
    if not has_accelerator():
        print("No compatible GPU found")
    elif has_apple_gpu_accelerator():
        print(
            "Printing from a kernel is not currently supporten on Apple silicon"
            " GPUs"
        )
    else:
        ctx = DeviceContext()
        ctx.enqueue_function[print_threads, print_threads](
            grid_dim=(2, 2, 1),
            block_dim=(16, 4, 2)
        )
        ctx.synchronize()
        print("Program finished")
