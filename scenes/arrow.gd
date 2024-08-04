extends Node2D
signal launch_angle

var arc_movement_player
var arc_movement_cpu
var angle = Vector2.ZERO
var arrow_position
var is_player

func _ready():
	hide()
	arc_movement_player = $AnimationPlayer.get_animation('arc_movement_player')
	arc_movement_cpu = $AnimationPlayer.get_animation('arc_movement_cpu')
	arc_movement_player.loop_mode = Animation.LOOP_LINEAR
	arc_movement_cpu.loop_mode = Animation.LOOP_LINEAR

func _process(delta):
	if Input.is_action_pressed("launch_ball") and is_player:
		_emit_position_player()
	elif not is_player and $CpuStartTimer.is_stopped():
		_emit_position_cpu()

func _emit_position_player():
	if $Sprite.position != Vector2(0, 0):
		arrow_position = $Sprite.position
		arrow_position.x = 150
		$AnimationPlayer.stop()
		hide()
		launch_angle.emit(arrow_position)

func _emit_position_cpu():
	if $Sprite.position != Vector2(0, 0):
		arrow_position = $Sprite.position
		arrow_position.x = -150
		$AnimationPlayer.stop()
		hide()
		launch_angle.emit(arrow_position)
		
func _on_left_wall_body_exited(body):
	$ArrowPosition.position.x = 1670
	$Sprite.flip_h = true
	$AnimationPlayer.play("arc_movement_cpu")
	position = $ArrowPosition.position	
	$CpuStartTimer.set_wait_time(randf_range(1.5, 3.5))
	$CpuStartTimer.start()
	is_player = false
	show()
	
func _on_right_wall_body_exited(body):
	$Sprite.flip_h = false
	$ArrowPosition.position.x = 250
	$AnimationPlayer.play("arc_movement_player")
	position = $ArrowPosition.position
	is_player = true	
	show()

func start_match():
	$Sprite.flip_h = false
	$ArrowPosition.position.x = 250
	$AnimationPlayer.play("arc_movement_player")
	position = $ArrowPosition.position
	is_player = true	
	show()


func _on_end_game():
	queue_free()


func _on_ball_bug():
	$TooFastTimer.start()


func _on_too_fast_timer_timeout():
	if is_player:
		$Sprite.flip_h = false
		$ArrowPosition.position.x = 250
		$AnimationPlayer.play("arc_movement_player")
		position = $ArrowPosition.position
	else:
		$ArrowPosition.position.x = 1670
		$Sprite.flip_h = true
		$AnimationPlayer.play("arc_movement_cpu")
		position = $ArrowPosition.position	
		$CpuStartTimer.set_wait_time(randf_range(1.5, 3.5))
		$CpuStartTimer.start()
	show()
