import pygatt

RAW_DATA_UUID = "0000002-0000-1000-8000-00805f9b34fb"
METRICS_UUID = '0000001-0000-1000-8000-00805f9b34fb'
MAC = '00:00:00:00:00:00'
# The BGAPI backend will attempt to auto-discover the serial device name of the
# attached BGAPI-compatible USB adapter.
adapter = pygatt.BGAPIBackend()

try:
    adapter.start()
    device = adapter.connect(MAC)
    value = device.char_read(RAW_DATA_UUID)
finally:
    adapter.stop()