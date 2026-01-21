from gpu.host import DeviceContext
from layout import Layout, LayoutTensor
from sys import has_accelerator

# Vector data type and size
comptime float_dtype = DType.float32
comptime vector_size = 1000

comptime layout = Layout.row_major(vector_size)

def main():
    @parameter
    if not has_accelerator():
        print("No compatible GPU found")
    else:
        # Get the context for the attached GPU
        ctx = DeviceContext()

        # Create HostBuffers for input vectors
        lhs_host_buffer = ctx.enqueue_create_host_buffer[float_dtype](vector_size)
        rhs_host_buffer = ctx.enqueue_create_host_buffer[float_dtype](vector_size)
        ctx.synchronize()

        # Initialize the input vectors
        for i in range(vector_size):
            lhs_host_buffer[i] = Float32(i)
            rhs_host_buffer[i] = Float32(i * 0.5)

        print("LHS buffer: ", lhs_host_buffer)
        print("RHS buffer: ", rhs_host_buffer)

        # Create DeviceBuffers for the input vectors
        lhs_device_buffer = ctx.enqueue_create_buffer[float_dtype](vector_size)
        rhs_device_buffer = ctx.enqueue_create_buffer[float_dtype](vector_size)

        # Copy the input vectors from the HostBuffers to the DeviceBuffers
        ctx.enqueue_copy(dst_buf=lhs_device_buffer, src_buf=lhs_host_buffer)
        ctx.enqueue_copy(dst_buf=rhs_device_buffer, src_buf=rhs_host_buffer)

        # Create a DeviceBuffer for the result vector
        result_device_buffer = ctx.enqueue_create_buffer[float_dtype](vector_size)

        # Wrap the DeviceBuffers in LayoutTensors
        lhs_tensor = LayoutTensor[float_dtype, layout](lhs_device_buffer)
        rhs_tensor = LayoutTensor[float_dtype, layout](rhs_device_buffer)
        result_tensor = LayoutTensor[float_dtype, layout](result_device_buffer)
