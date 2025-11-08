from py4godot.methods import private
from py4godot.signals import signal, SignalArg
from py4godot.classes import gdclass
from py4godot.classes.core import Vector3
from py4godot.classes.Node import Node

import asyncio
from pynecil import Pynecil, CharLive, discover, CommunicationError

@gdclass
class pinecil_bt(Node):
	pynecil_client = None
	loop = None

	def _ready(self) -> None:
		if self.loop == None:
			self.loop = asyncio.new_event_loop()
			
		print(self.loop)
		print(self.pynecil_client)
		if self.pynecil_client == None:
			device = self.loop.run_until_complete(discover(timeout=3))
			print(device)
			if device != None:
				self.pynecil_client = Pynecil(device)

		print(self.pynecil_client)

	def get_current_temperature(self) -> int:
		temperature = -1
		if self.pynecil_client != None:
			try:
				temperature = self.loop.run_until_complete(self.pynecil_client.read(CharLive.SETPOINT_TEMP))
			except (TimeoutError, CommunicationError):
				temperature = -1
		return temperature
	
	def get_accelerometer_x(self) -> int:
		value = 0
		if self.pynecil_client != None:
			try:
				value = self.loop.run_until_complete(self.pynecil_client.read())

	def _exit_tree(self):
		if self.pynecil_client != None:
			self.pynecil_client.disconnect()
			self.pynecil_client = None
