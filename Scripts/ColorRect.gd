extends ColorRect


func make_green():
	color = Color.GREEN
	$Timer.start(0.25)


func make_red():
	color = Color.RED
	$Timer.start(0.25)


func _on_timer_timeout():
	color = Color.DARK_GRAY
