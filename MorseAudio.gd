extends AudioStreamPlayer


var sample_hz = 16050.0 # Keep the number of samples to mix low, GDScript is not super fast.
var pulse_hz = 400.0
var phase = 0.0

var playback: AudioStreamPlayback = null

var random = RandomNumberGenerator.new()
@export var rand_range: float = 0.1

func _fill_buffer():
	var increment = pulse_hz / sample_hz

	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		var frame = Vector2.ONE * sin(phase * TAU)
		playback.push_frame(frame)  # Audio frames are stereo.
		var r = random.randf_range(-rand_range, rand_range)
		var next_phase = phase + increment + r
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1


func _ready():
	stream.mix_rate = sample_hz # Setting mix rate is only possible before play().
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
