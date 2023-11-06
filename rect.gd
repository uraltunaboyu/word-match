extends ColorRect

const TWEEN_TIMER = 0.1

func flash():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", 
								Color(1.0, 0.0, 0.0, 1.0), TWEEN_TIMER)
	tween.tween_property(self, "color", 
								Color(1.0, 0.0, 0.0, 0.0), TWEEN_TIMER)
