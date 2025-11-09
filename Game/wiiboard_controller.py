from py4godot.classes import gdclass
from py4godot.classes.core import Vector2, Vector4
from py4godot.classes.Node import Node
from py4godot.signals import signal, SignalArg

import time
from threading import Thread

try:
	from wiiboard import Wiiboard, discover_wiiboards
	HAS_WIIBOARD = True
except:
	print("Failed to load the wiiboard library")
	def discover_wiiboards(*_args, **_kwargs):
		return []
	class Wiiboard:
		pass
	HAS_WIIBOARD = False


class WeightMeasurement:
	def __init__(self, timepoint: float, weight: float):
		self.timepoint = timepoint
		self.weight = weight


@gdclass
class wiiboard_controller(Node):
	wiiboard_lib_loaded = HAS_WIIBOARD

	jump = signal()

	## Minimum difference between min and max weight spikes required to trigger
	## a "jump" signal
	JUMP_DELTA = 130.0

	board_connected: bool = False
	board_address: str = ''
	
	board: Wiiboard = None
	board_thread: Thread = None
	
	weights: dict[str, float] = {
		"top_right":    0.0,
		"bottom_right": 0.0,
		"top_left":     0.0,
		"bottom_left":  0.0
	}
	
	_weight_history = []
	_jump_timeout = 0.0

	if HAS_WIIBOARD:
		def _ready(self) -> None:
			boards = discover_wiiboards(1)
			print(f"Found {len(boards)} wii board(s)")
			if (boards):
				self.board_address = boards[0]
				print(f"Connecting to WiiBoard: {self.board_address}")
				self.board = Wiiboard()
				self.board.connect(self.board_address)
				print("Connected, Starting WiiBoard Controller...")
				self.board_thread = Thread(target=self.board.loop)
				self.board_thread.start()
				self.board_connected = True
			else:
				print("No WiiBoards found!")


	def _process(self, _delta: float) -> None:
		if self.board is None:
			return
		self.weights = self.board.corners
		self._process_jump()


	def _process_jump(self):
		time_point = time.time()
		if time_point > self._jump_timeout:
			total_weight = sum(self.weights.values())
			self._weight_history.append(WeightMeasurement(time_point, total_weight))
			# Keep only last second of history
			self._weight_history = [m for m in self._weight_history if time_point - m.timepoint <= 1.0]
			weights = [m.weight for m in self._weight_history]
			m_max = max(weights)
			m_min = min(weights)
			if m_max - m_min > 130.0:
				self.jump.emit()
				# Reset history and sleep for 1 second
				self._weight_history = []
				self._jump_timeout = time_point + 1.0


	def get_weights(self) -> Vector4:
		return Vector4.new3(*self.weights.values())


	def get_center_of_mass(self):
		corners = list(self.weights.values())
		x = corners[0] + corners[1] - corners[2] - corners[3]
		y = corners[1] + corners[3] - corners[0] - corners[2]
		return Vector2.new3(x, y)
