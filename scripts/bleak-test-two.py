import asyncio
from bleak import BleakClient

UUID = '00000003-0000-1000-8000-00805f9b34fb'
mac = '00:00:00:08:08:01'


def callback(sender: int, data: bytearray):
    print(f"{sender}: {len(data)}")

async def main():
    client = BleakClient(mac)
    await client.connect()
    print('connected')
    await client.start_notify(UUID, callback)
    while True:
        pass

if __name__ == '__main__':
    asyncio.run(main())