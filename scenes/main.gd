extends Node

signal wind

# Called when the node enters the scene tree for the first time.
func _ready():
	$Arrow.start_match()
	$GameMusic.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_hud_end():
	$GameMusic.stop()
	queue_free()


func _on_ball_launch():
	$WindTimer.start()


func _on_wind_timer_timeout():
	wind.emit()


func _on_game_hud_wind_init(velocity):
	if velocity.x > 0:
		# Vent venant de la gauche, positionner à gauche de l'écran
		$Wind.position = Vector2(0, 540)
		$Wind.gravity = Vector2(980, 0)  # Pousse vers la droite
	elif velocity.x < 0:
		# Vent venant de la droite, positionner à droite de l'écran
		$Wind.position = Vector2(1920, 540)
		$Wind.gravity = Vector2(-980, 0)  # Pousse vers la gauche
	elif velocity.y > 0:
		# Vent venant du haut, positionner au-dessus de l'écran
		$Wind.position = Vector2(960, 0)
		$Wind.gravity = Vector2(0, 980)  # Pousse vers le bas
	elif velocity.y < 0:
		# Vent venant du bas, positionner en dessous de l'écran
		$Wind.position = Vector2(960, 1080)
		$Wind.gravity = Vector2(0, -980)  # Pousse vers le haut
	
	$Wind.emitting = true
