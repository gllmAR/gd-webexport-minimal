extends Button

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("go_mallet"):
		self._on_pressed()

func _on_pressed() -> void:
	$"./AudioStreamPlayer-mallet".play()
