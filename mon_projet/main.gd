extends Control

var hue_progress = 0

func _process(delta):
	if Input.is_action_just_pressed("go_mallet"):
		_go_mallet()
	if Input.is_action_just_pressed("go_surge"):
		_go_surge()

func _go_mallet():
	$"mallet/AudioStreamPlayer".play()
	$"mallet/ColorRect".color=Color(randfn(0.2, 1.0),randfn(0.2, 1.0),randfn(0.2, 1.0),1)
	_change_background_hue()
	
func _go_surge():
	$"surge/AudioStreamPlayer".play()
	$"surge/ColorRect".color=Color(randfn(0.2, 1.0),randfn(0.2, 1.0),randfn(0.2, 1.0),1)
	_change_background_hue()
	
func _change_background_hue():
	hue_progress = wrapf(hue_progress + 0.01, 0.0, 1.0)
	$"TextureRect-background".modulate=Color.from_hsv(hue_progress, 1, 1, 1)

func _on_buttonmallet_pressed() -> void:
	_go_mallet()
	
func _on_buttonsurge_pressed() -> void:
	_go_surge()
