from py4godot.methods import private
from py4godot.signals import signal, SignalArg
from py4godot.classes import gdclass
from py4godot.classes.core import Vector3
from py4godot.classes.Node import Node

import asyncio
try:
	from pynecil import Pynecil, CharLive, CharGameJam, discover, CommunicationError, PinecilMenus
	HAS_PINECIL = True
except:
	print("Failed to load the pinecil library")
	HAS_PINECIL = False

@gdclass
class pinecil_bt(Node):
	pinecil_lib_loaded = HAS_PINECIL
	pinecil_connected = False

	pynecil_client = None
	loop = None

	def _ready(self) -> None:
		if HAS_PINECIL:
			if self.loop is None:
				self.loop = asyncio.new_event_loop()
				
			if self.pynecil_client is None:
				device = self.loop.run_until_complete(discover(timeout=3))
				if device is not None:
					print(f"Found Pinecil: {device}")
					self.pynecil_client = Pynecil(device)
					self.pinecil_connected = True
				else:
					print("No Pinecil found!")

	def get_current_temperature(self) -> int:
		temperature = -1
		if self.pynecil_client is not None:
			try:
				temperature = self.loop.run_until_complete(self.pynecil_client.read(CharLive.SETPOINT_TEMP))
			except (TimeoutError, CommunicationError) as e:
				print("get_current_temperature() Error: {}".format(e))
				temperature = -1
		return temperature

	def get_accelerometer_value_x(self) -> int:
		value = 0
		if self.pynecil_client is not None:
			try:
				value = self.loop.run_until_complete(self.pynecil_client.read(CharGameJam.ACCEL)).x
			except (TimeoutError, CommunicationError) as e:
				print("Pynecil Error: {}".format(e))
				value = 0
		return value
	
	def get_current_menu(self):
		menu = None
		if self.pynecil_client is not None:
			try:
				menu = self.loop.run_until_complete(self.pynecil_client.read(CharGameJam.MENU))
			except (TimeoutError, CommunicationError) as e:
				print("get_current_menu() Error: {}".format(e))
		return menu

	
	def change_menu(self, menu) -> bool:
		print(menu)
		if self.pynecil_client is not None:
			try:
				self.loop.run_until_complete(self.pynecil_client.write(CharGameJam.MENU, menu))
				return True
			except (TimeoutError, CommunicationError) as e:
				print("change_menu() Error: {}".format(e))
		return False

	def _exit_tree(self):
		if self.pynecil_client is not None:
			self.pynecil_client.disconnect()
			self.pynecil_client = None
			self.pinecil_connected = False
