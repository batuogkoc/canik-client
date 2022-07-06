import numpy as np

# with open('data.bin', 'rb') as f:
#     raw_data = f.read()
#     print(len(raw_data))
#     data = np.frombuffer(raw_data, dtype=np.dtype("<i2"), offset=7).reshape((6,20))
#     print(data)


with open('27.bin', 'rb') as f:
    raw_data = f.read()
    print(int.from_bytes(raw_data[0:2], "little", signed=False))

