from py4godot.classes import gdclass
from py4godot.classes.core import Vector2, Vector4
from py4godot.classes.Node import Node

from threading import Thread

import wiiboard

@gdclass
class wiiboard_controller(Node):
	board_connected: bool = False
	board_address: str = ''
	
	board: wiiboard.Wiiboard = None
	board_thread: Thread = None
	
	weights: dict[str, float] = {
		"top_right":    0.0,
		"bottom_right": 0.0,
		"top_left":     0.0,
		"bottom_left":  0.0
	}
	
	def _ready(self) -> None:
		print("Searching wii boards...")
		boards = wiiboard.discover_wiiboards(5)
		if (boards):
			self.board_address = boards[0]
			print("Connecting to WiiBoard:", self.board_address)
			self.board = wiiboard.Wiiboard()
			self.board.connect(self.board_address)
			print("Connected, Starting WiiBoard Controller...")
			self.board_thread = Thread(target=self.board.loop)
			self.board_thread.start()
			self.board_connected = True
		else:
			print("No WiiBoards found!")

	def _process(self, delta:float) -> None:
		if self.board is not None:
			self.weights = self.board.corners
	
	def get_weights(self) -> Vector4:
		return Vector4.new3(*self.weights.values())
	
	def get_center_of_mass(self):
		corners = list(self.weights.values())
		x = corners[0] + corners[1] - corners[2] - corners[3]
		y = corners[1] + corners[3] - corners[0] - corners[2]
		return Vector2.new3(x, y)
