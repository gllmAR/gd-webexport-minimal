extends Control

# Contrôleur principal de la scène.
#
# Comportement : écoute deux actions d'entrée ("go_mallet" et "go_surge").
# Lorsqu'une action est déclenchée, le script :
# - joue l'AudioStreamPlayer correspondant (noeuds attendus ci-dessous),
# - change la couleur du ColorRect lié,
# - et fait évoluer la teinte (hue) du fond via la propriété `modulate` de
#   `TextureRect-background`.
#
# Actions d'entrée (Project Settings > Input Map) attendues :
# - "go_mallet"  -> joue le son / change la couleur pour "mallet"
# - "go_surge"   -> joue le son / change la couleur pour "surge"
#


var hue_progress: float = 0.0

func _process(delta: float) -> void:
	# Appelée chaque frame par Godot. Surveille les actions d'entrée et
	# délègue aux fonctions correspondantes.
	if Input.is_action_just_pressed("go_mallet"):
		_go_mallet()
	if Input.is_action_just_pressed("go_surge"):
		_go_surge()

func _go_mallet() -> void:
	# Fonction pour l'action "go_mallet".
	# Effets secondaires : lecture du son, changement de couleur, mise à jour
	# de la teinte de l'arrière-plan.
	$"mallet/AudioStreamPlayer".play()
	$"mallet/ColorRect".color = Color(randfn(0.2, 1.0), randfn(0.2, 1.0), randfn(0.2, 1.0), 1)
	_change_background_hue()

func _go_surge() -> void:
	# Fonction pour l'action "go_surge".
	# Effets secondaires : lecture du son, changement de couleur, mise à jour
	# de la teinte de l'arrière-plan.
	$"surge/AudioStreamPlayer".play()
	$"surge/ColorRect".color = Color(randfn(0.2, 1.0), randfn(0.2, 1.0), randfn(0.2, 1.0), 1)
	_change_background_hue()

func _change_background_hue() -> void:
	# Fait progresser `hue_progress` de 0.01, puis l'enroule dans [0,1] via
	# `wrapf` pour assurer une rotation continue des teintes.
	hue_progress = wrapf(hue_progress + 0.01, 0.0, 1.0)
	# Applique la teinte calculée au TextureRect de fond en utilisant HSV.
	$"TextureRect-background".modulate = Color.from_hsv(hue_progress, 1, 1, 1)

func _on_buttonmallet_pressed() -> void:
	# Signal attaché au bouton 'mallet' dans l'éditeur : déclenche _go_mallet().
	_go_mallet()

func _on_buttonsurge_pressed() -> void:
	# Signal attaché au bouton 'surge' dans l'éditeur : déclenche _go_surge().
	_go_surge()
