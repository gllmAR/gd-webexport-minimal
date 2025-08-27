extends Control

# Minimal : gère deux actions (mallet/surge), joue les sons et effectue des
# fondus (interpolation) des ColorRect et de la couleur du fond.

# Vitesse d'interpolation des ColorRect (modifiable dans l'éditeur)
@export var color_lerp_speed: float = 10.0
# Vitesse d'interpolation de la couleur du fond (modifiable dans l'éditeur)
@export var bg_lerp_speed: float = 10.0

# Progression de la teinte (0.0..1.0) utilisée pour calculer la couleur du fond
var hue_progress: float = 0.0

# Dictionnaire des couleurs cibles pour chaque instrument et le fond
# _targets["mallet"] / _targets["surge"] -> Color cible pour le ColorRect
# _targets["bg"] -> Color cible pour le TextureRect-background
var _targets := {"mallet": null, "surge": null, "bg": null}

# Liste des préfixes instruments utilisés pour itération
const PREFIXES := ["mallet", "surge"]

func _ready() -> void:
	# Initialisation : empêche que les mêmes couleurs se répètent entre runs
	randomize()
	# Récupère les couleurs initiales des ColorRect si présents et les stocke
	for p in PREFIXES:
		var r = get_node_or_null("%s/ColorRect" % p)
		if r:
			_targets[p] = r.color
	# Récupère la couleur courante du fond (modulate) si présent
	var bg = get_node_or_null("TextureRect-background")
	if bg:
		_targets["bg"] = bg.modulate

func _process(delta: float) -> void:
	# Vérifie les actions d'entrée (touches / boutons) et déclenche l'instrument
	if Input.is_action_just_pressed("go_mallet"):
		_trigger("mallet")
	if Input.is_action_just_pressed("go_surge"):
		_trigger("surge")

	# Applique un lerp (fondu linéaire) vers les couleurs cibles pour chaque ColorRect
	var t = clamp(color_lerp_speed * delta, 0, 1)
	for p in PREFIXES:
		var rect = get_node_or_null("%s/ColorRect" % p)
		if rect and _targets[p]:
			rect.color = rect.color.lerp(_targets[p], t)

	# Applique un lerp pour la couleur du fond (modulate)
	var bg = get_node_or_null("TextureRect-background")
	if bg and _targets["bg"]:
		bg.modulate = bg.modulate.lerp(_targets["bg"], clamp(bg_lerp_speed * delta, 0, 1))

func _trigger(prefix: String) -> void:
	# Joue l'audio associé si le AudioStreamPlayer est présent
	var player = get_node_or_null("%s/AudioStreamPlayer" % prefix)
	if player:
		player.play()
	# Définit une nouvelle couleur cible aléatoire pour l'instrument
	_targets[prefix] = Color(randf_range(0.2, 1.0), randf_range(0.2, 1.0), randf_range(0.2, 1.0), 1)
	# Si l'instrument est 'surge', on décrémente la teinte ; sinon on l'incrémente
	if prefix == "surge":
		hue_progress = wrapf(hue_progress - 0.01, 0.0, 1.0)
	else:
		hue_progress = wrapf(hue_progress + 0.01, 0.0, 1.0)
	# Met à jour la couleur cible du fond à partir de la teinte calculée
	_targets["bg"] = Color.from_hsv(hue_progress, 1, 1, 1)

func _on_buttonmallet_pressed() -> void:
	# Handler du signal bouton 'mallet' (lié dans l'éditeur)
	_trigger("mallet")

func _on_buttonsurge_pressed() -> void:
	# Handler du signal bouton 'surge' (lié dans l'éditeur)
	_trigger("surge")
