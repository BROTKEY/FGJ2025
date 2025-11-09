import asyncio, time
from pynecil import discover, Pynecil, const, CharGameJam, PinecilMenus

async def main():

    device = await discover()
    client = Pynecil(device)

    device_info = await client.get_device_info()

    screen = await client.read(CharGameJam.MENU)
    print(screen)

asyncio.run(main())