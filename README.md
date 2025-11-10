# Untitled Chicken Game

## Dependencies:
- Godot 4.5.1
- ?py4godot?
### py-packages
#### Linux / Mac
!!!!Please chnge cpy to your os version!!!!!!
aswell as: chmod +x ./addons/py4godot/cpython-3.12.4-linux64/python/bin/python

- pybluez: ./cpython-3.12.4-linux64/python/bin/python -m pip install --force-reinstall --no-cache "git+https://github.com/pybluez/pybluez.git#egg=pybluez"
  - might require a additional bluetooth install on your distro of choice:
  - sudo apt install clang
  - sudo apt-get install libbluetooth-dev
- ./addons/py4godot/cpython-3.12.4-linux64/python/bin/python -m pip install -r ./addons/py4godot/dependencies.txt

### Windows
- pywinusb: `.\addons\py4godot\cpython-3.12.4-win64\python\python.exe -m pip install pywinusb`
- `.\addons\py4godot\cpython-3.12.4-win64\python\python.exe -m pip install -r .\addons\py4godot\dependencies.txt`

## Devices

### Pinecil
TODO

### MIDI Keyboard
Should be working out of the box. Piano keys and volume slider are used.

### WiiFit Balance Board
This requires some extra setup.

#### Linux / Mac
1. Make sure Bluetooth is enabled and available
2. Press and hold the red "SYNC" button on the board within the battery case
3. Start the game while still holding the button. Don't release it before the main menu is loaded.
4. If successful, the balance board icon should be visible on the left in the main menu

#### Windows
1. Make sure Bluetooth is enabled
2. Download and start [WiiBalanceWalker](https://github.com/lshachar/WiiBalanceWalker/releases)
3. Press the button "Add/Remove bluetooth Wii device" and follow the instructions to pair the board
4. Start the game
5. If successful, the balance board icon should be visible on the left in the main menu
