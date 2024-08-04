extends StaticBody2D
class_name Player
@export var speed = 1600
var screen_size
var racket_height
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2.ZERO
	position = $StartPositionPlayer.position
	screen_size = get_viewport_rect().size
	racket_height = $RacketSprite.texture.get_size().y * 0.4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	var new_position = position + velocity * delta
	# Clamp the position taking into account the racket's height
	new_position.y = clamp(new_position.y, racket_height / 2, screen_size.y - racket_height / 2)
	position = new_position


func _on_left_wall_body_exited(body):
	position = $StartPositionPlayer.position


func _on_right_wall_body_exited(body):
	position = $StartPositionPlayer.position

 
func _on_end_game():
	hide()
