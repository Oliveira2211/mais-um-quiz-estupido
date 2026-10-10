extends Timer

@onready var timer_label: Label = %TimerLabel

var ds: int
var s: int


#--- Public functions
func restart():
	ds = 0
	s = 30
	start()


#--- Control signals
func _on_timeout() -> void:
	if s == 0 and ds == 0:
		get_parent().game_over()
		stop()
	else:
		if ds == 0:
			ds = 9
			s -= 1
		ds -= 1
	
	timer_label.text = ("%02d:%01d" % [s, ds])
