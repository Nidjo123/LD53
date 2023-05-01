extends AudioStreamPlayer


@export var sample_hz: float = 16050.0 # Keep the number of samples to mix low, GDScript is not super fast.
@export var pulse_hz: float = 320.0
@export var rand_range: float = 0.1


var phase = 0.0


func _on_morse_controller_telegraph_pressed():
	play()


func _on_morse_controller_telegraph_released():
	stop()


func volume_changed(new_volume_db):
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, new_volume_db)
