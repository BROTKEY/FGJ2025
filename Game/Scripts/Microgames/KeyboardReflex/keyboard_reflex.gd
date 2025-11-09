extends BaseMicrogame

var difficulty: float = 1.0
var won: bool = true
var start_time = 0
var tollerance = 150
var note_jump_offset_mult = 0.4

var height = 0
var hitline = 0

var note = 0
var song = [{"key": 4, "timestamp": 1875.0}, {"key": 2, "timestamp": 2187.0}, {"key": 4, "timestamp": 2500.0}, {"key": 4, "timestamp": 3750.0}, {"key": 7, "timestamp": 4062.0}, {"key": 5, "timestamp": 4375.0}]

func handle_keystrokes(keyId, state) -> void:
	var time_d = Time.get_ticks_msec() - start_time  
	var key = get_node("Keys/Key%s" % keyId)
	if !key or !won:
		return
		
	if state:
		(key as ColorRect).color = Color(0.585, 0.585, 0.585, 1.0)
		print(time_d)
		print(song[note]["timestamp"])
		if time_d < song[note]["timestamp"] + tollerance and time_d > song[note]["timestamp"] - tollerance and keyId == song[note]["key"]:
			var particles = get_node("Keys/Key%s/Particels" % keyId) as GPUParticles2D
			particles.emitting = true
			note += 1
		else: 
			(key as ColorRect).color = Color(0.618, 0.0, 0.051, 1.0)
			won = false
	else:
		(key as ColorRect).color = Color(1.0, 1.0, 1.0, 1.0)

func _ready() -> void:
	start_time = Time.get_ticks_msec()
	height = get_viewport().size.y
	hitline = $Keys.position.y
	InputManager.keystroke.connect(handle_keystrokes)
	for i in range(len(song)):
		var keyboard_key = get_node("Keys/Key%s" % song[i]["key"]) as ColorRect
		
		var rect = ColorRect.new()
		rect.position = Vector2(keyboard_key.position.x, -500)
		rect.size = Vector2(40, 120)
		rect.color = Color(0.0, 0.0, 0.0, 1.0)
		
		$Indicators.add_child(rect, true)
	
	
func _process(delta: float) -> void:
	var elap_time = Time.get_ticks_msec() - start_time
	
	for i in range(len(song)):
		var pos = (elap_time - song[i]["timestamp"]) * note_jump_offset_mult + hitline - 60
		
		var test = "Indicators/ColorRect%s" % ("" if i == 0 else i+1)
		
		var indicator = get_node(test) as ColorRect
		indicator.position.y = pos

func get_difficulty() -> float:
	return difficulty

func set_difficulty(value: float) -> void:
	difficulty = value

func get_won() -> bool:
	return won

func get_game_name() -> String:
	return 'KeyboardReflex'

func get_input_device() -> InputManager.InputDevice:
	return InputManager.InputDevice.MIDI_KEYBOARD
