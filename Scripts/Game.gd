extends Spatial


func _ready():
	Globals.camera= $Camera



func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_ESCAPE:
					get_tree().quit()
