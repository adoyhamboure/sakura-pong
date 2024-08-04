extends CharacterBody2D

signal ball_exited_left
signal ball_exited_right
signal bug
signal launch
signal position_for_wind

var direction
var has_been_launched = false;
var has_entered = false
var collision_cooldown = 0.05  # Délai minimum en secondes
var time_since_last_collision = 0.0
var time_since_last_wall_collision = 0.0
var too_fast_emitted = false

@export var speed = 1000 # Vitesse de la balle

func _ready():
	position = $BallStartPosition.position
	$CPUParticles2D.emitting = false
	velocity = Vector2.ZERO
	$Sprite2D.play()
	$Sprite2D.animation = 'default'	
	

func _physics_process(delta):
	if has_been_launched and too_fast_emitted == false:
		time_since_last_collision += delta
		time_since_last_wall_collision += delta
	if time_since_last_collision > 6.0 and has_been_launched == true and too_fast_emitted == false:
		too_fast_emitted = true
		bug.emit()
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		# Inverser la direction en cas de collision
		velocity = velocity.bounce(collision_info.get_normal())
		time_since_last_collision = 0.0
		if speed <= 3000:
			speed = speed + 25
	position += velocity * speed * delta


func _on_left_wall_body_exited(body):
	ball_exited_left.emit()
	$BallStartPosition.position.x = 1770
	has_been_launched = false
	$CPUParticles2D.emitting = false	
	hide()
	_launch_new_ball()

func _on_right_wall_body_exited(body):
	ball_exited_right.emit()
	$BallStartPosition.position.x = 150
	has_been_launched = false
	$CPUParticles2D.emitting = false	
	hide()
	_launch_new_ball()

func _launch_new_ball():
	position = $BallStartPosition.position
	show()
	$CollisionShape2D.disabled = false
	velocity = Vector2.ZERO
	speed = 1000
	$Sprite2D.animation = 'default'

func _on_arrow_launch_angle(arrow_position):
	direction = arrow_position.normalized()
	velocity = direction
	has_been_launched = true
	$CPUParticles2D.emitting = true
	$Sprite2D.animation = 'rotating_right'
	launch.emit()

func _on_wall_body_entered(body):
	if body == self and time_since_last_wall_collision >= collision_cooldown:
		velocity.y = -velocity.y
		time_since_last_wall_collision = 0.0
		time_since_last_collision = 0.0
	if speed <= 3000:
		speed = speed + 25


func _on_end_game():
	queue_free()

func _on_game_hud_reset_ball(is_player):
	too_fast_emitted = false
	time_since_last_collision = 0.0
	time_since_last_wall_collision = 0.0
	if is_player:
		$BallStartPosition.position.x = 150
		has_been_launched = false
		$CPUParticles2D.emitting = false
		_launch_new_ball()
	else:
		$BallStartPosition.position.x = 1770
		has_been_launched = false
		$CPUParticles2D.emitting = false
		_launch_new_ball()


func _on_main_wind():
	position_for_wind.emit(velocity)


func _on_game_hud_wind_init(wind_velocity):
	if has_been_launched:
		if velocity.x + wind_velocity.x <= 1 and velocity.x + wind_velocity.x >= -1:
			velocity.x = wind_velocity.x + velocity.x
		if velocity.y + wind_velocity.y <= 1 and velocity.y + wind_velocity.y >= -1:
			velocity.y = wind_velocity.y + velocity.y
		
