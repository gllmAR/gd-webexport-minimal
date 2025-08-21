extends Button

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("go_surge"):
		self._on_pressed()

func _on_pressed() -> void:
	$"./AudioStreamPlayer-surge".play()
	pass # Replace with function body.
