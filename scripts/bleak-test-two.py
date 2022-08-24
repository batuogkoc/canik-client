import asyncio
from bleak import BleakClient

RAW_DATA_UUID = "00000002-0000-1000-8000-00805f9b34fb"
mac = '00:80:E1:26:2C:D5'


def callback(sender: int, data: bytearray):
    print(f"{sender}: {len(data)}")

async def main():
    client = BleakClient(mac)
    await client.connect()
    print('connected')
    await client.start_notify(RAW_DATA_UUID, callback)
    while True:
        await asyncio.sleep(100)

if __name__ == '__main__':
    asyncio.run(main())