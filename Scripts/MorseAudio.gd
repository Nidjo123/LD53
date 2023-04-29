extends AudioStreamPlayer


@export var sample_hz: float = 16050.0 # Keep the number of samples to mix low, GDScript is not super fast.
@export var pulse_hz: float = 320.0
@export var rand_range: float = 0.1

var phase = 0.0
var playback: AudioStreamPlayback = null

func _fill_buffer():
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		var frame = Vector2.ONE * sin(phase * TAU)
		playback.push_frame(frame)  # audio frames are stereo
		var next_phase = phase + increment
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1


func _ready():
	stream.mix_rate = sample_hz # setting mix rate is only possible before play()
	play()
	stream_paused = true
	playback = get_stream_playback()
	_fill_buffer()


func _process(delta):
	_fill_buffer()
	
	if Input.is_action_just_pressed("ui_down"):
		stream_paused = false
	elif Input.is_action_just_released("ui_down"):
		stream_paused = true
