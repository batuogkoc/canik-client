import asyncio
import bleak
from bleak import BleakScanner, BleakClient, discover

RAW_DATA_UUID = "0000002-0000-1000-8000-00805f9b34fb"
METRICS_UUID = '0000001-0000-1000-8000-00805f9b34fb'

UUID = '00000003-0000-1000-8000-00805f9b34fb'

""" mac_batu_samsung = 'E8:6D:CB:62:B5:D7'
mac_apple = '56:08:2E:83:6A:B5'
 """

def callback(sender: int, data: bytearray):
    print(sender, data)
    if sender == 21:
        with open('dimport asyncio
import bleak
from bleak import BleakScanner, BleakClient, discover

RAW_DATA_UUID = "0000002-0000-1000-8000-00805f9b34fb"
METRICS_UUID = '0000001-0000-1000-8000-00805f9b34fb'

UUID = '00000003-0000-1000-8000-00805f9b34fb'

""" mac_batu_samsung = 'E8:6D:CB:62:B5:D7'
mac_apple = '56:08:2E:83:6A:B5'
 """

def callback(sender: int, data: bytearray):
    print(sender, data)
    if sender == 21:
        with open('data.bin', 'wb') as f:
            f.write(data)


async def main():
    while True:
        print()
        print()
        devices = await discover()
        # devices = await BleakScanner.discover()
        caniks = []
        for d in devices:
            try:
                if d.name.strip() == 'MyCanik':
                    print(f'found canik')
                    caniks.append(d)
            except Exception as e:
                pass
        print(f'found {len(caniks)} caniks.')
        for i, canik in enumerate(caniks):
            print(f'connecting to canik {i} at address {canik.address}')
            await connect(canik.address)


async def connect(address):
    client = BleakClient(address)
    # try:
    await client.connect()
    service_dict = {}
    print('connected')
    services = await client.get_services()
    print('found ' + str(len(services.services.keys())) + ' services')
    for i, service in enumerate(services.services.values()):
        service_dict[service] = []
        for characteristic in service.characteristics:
            service_dict[service].append(characteristic)

    for service in service_dict.keys():
        for characteristic in service_dict[service]:
            try:
                await client.start_notify(characteristic.uuid, callback)
                # print(service.description, characteristic.uuid, characteristic.handle)
            except Exception as e:
                # print(e)
                continue
            except PermissionError as pe:
                print(pe)
                continue
            except bleak.exc.BleakError as be:
                print(be)
                continue
            

   
    while True:
        pass   
    # metrics_service = services.get_service(METRICS_UUID)
    # print(metrics_service)
    # raw_data_characteristic = metrics_service.get_characteristic(RAW_DATA_UUID)
    # print(raw_data_characteristic)
    # except Exception as e:
    #     print(e)
    # finally:
    #     await client.disconnect()


if __name__ == '__main__':
    asyncio.run(main())
