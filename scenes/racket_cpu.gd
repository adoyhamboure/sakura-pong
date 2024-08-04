extends StaticBody2D
class_name CPU

@export var speed = 1200
var screen_size
var racket_height
var ball
var velocity = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.difficulty == 'easy':
		speed = 600
	if Global.difficulty == 'normal':
		speed = 800
	if Global.difficulty == 'impossible':
		speed = 1200
	position = $StartPositionCpu.position
	screen_size = get_viewport_rect().size
	racket_height = $RacketSprite.texture.get_size().y * 0.4
	# Rechercher la balle dans la scène (assurant que la balle est en scène avant cet appel)
	ball = get_parent().get_node("Ball")
	if ball == null:
		print("Erreur: La balle n'a pas été trouvée")

func _physics_process(delta):
	if ball != null:
		# Obtenir la position actuelle de la balle
		var ball_position = ball.position

		# Calculer la direction de déplacement pour suivre la balle
		if ball_position.y > position.y:
			velocity.y = speed
		elif ball_position.y < position.y:
			velocity.y = -speed
		else:
			velocity.y = 0

		# Déplacer la raquette
		velocity = velocity.normalized() * speed
		position += velocity * delta

# Empêcher la raquette de sortir de l'écran (comme pour le joueur)
 # Supposant un nœud Sprite pour la raquette
		position.y = clamp(position.y, racket_height / 2, screen_size.y - racket_height / 2)


func _on_right_wall_body_exited(body):
	position = $StartPositionCpu.position


func _on_left_wall_body_exited(body):
	position = $StartPositionCpu.position


func _on_end_game():
	hide()
