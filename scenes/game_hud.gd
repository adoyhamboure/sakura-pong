extends CanvasLayer

signal has_win
signal has_lose
signal reset_ball
signal wind_init

var player_score = 0
var cpu_score = 0
var current_drop = 1
var is_player = true
var wind_velocity = Vector2.ZERO

@onready var animation_player_player = $ScorePlayer/AnimationPlayer
@onready var animation_player_player2 = $ScorePlayer/AnimationPlayer2
@onready var animation_player_cpu = $ScoreCpu/AnimationPlayer
@onready var animation_player_cpu2 = $ScoreCpu/AnimationPlayer2
@onready var animation_player_separator = $Separator/AnimationPlayer

signal end

# Called when the node enters the scene tree for the first time.
func _ready():
	$WindIncoming.hide()
	$WindIncoming/WindAnimPlayer.play("bounce")
	$TooFast.hide()
	$EndLabel.hide()
	$PressSpace.hide()
	$StartDropTimer.start()
	animation_player_separator.get_animation('movement').loop_mode = Animation.LOOP_LINEAR	
	animation_player_separator.play('movement')
	animation_player_player2.play("move_player")
	animation_player_cpu2.play("move_cpu")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cpu_score == 10 or player_score == 10:
		if Input.is_action_pressed("end_game"):
			end.emit()
			get_tree().change_scene_to_file("res://scenes/menu.tscn")

func init_score():
	player_score = 0
	cpu_score = 0
	$ScorePlayer.text = str(player_score)
	$ScoreCpu.text = str(cpu_score)

func update_score_player():
	is_player = true
	player_score += 1
	$ScorePlayer.text = str(player_score)
	animation_player_player.play("bounce")
	if player_score == 10:
		win()
		
func win():
	$EndLabel.text = 'victory'
	$EndLabel.show()
	$PressSpace.show()
	$EndLabel/EndLabelPlayer.play("scale")
	$EndLabel/EndLabelPlayer2.play("buzz")
	$PressSpace/AnimationPlayer.play("slow_bounce")
	has_win.emit()

func lose():
	$EndLabel.text = 'loser'
	$EndLabel.show()
	$PressSpace.show()
	$EndLabel/EndLabelPlayer.play("scale")
	$EndLabel/EndLabelPlayer2.play("buzz")
	$PressSpace/AnimationPlayer.play("slow_bounce")
	has_lose.emit()

func update_score_cpu():
	is_player = false	
	cpu_score += 1
	$ScoreCpu.text = str(cpu_score)
	animation_player_cpu.play("bounce")
	if cpu_score == 10:
		lose()

func _on_ball_ball_exited_left():
	update_score_cpu()


func _on_ball_ball_exited_right():
	update_score_player()

func _on_bounce_timer_timeout():
	animation_player_cpu.play("bounce")
	animation_player_player.play("bounce")


func _on_end_drop_timer_timeout():
	$BounceTimer.stop()
	$ColorRect/ColorAnimPlayer.stop()
	$StartDropTimer.wait_time = 53.0 if current_drop == 1 else 40.2
	$StartDropTimer.start()
	if current_drop == 1:
		current_drop = 2
	else:
		current_drop = 1


func _on_start_drop_timer_timeout():
	$BounceTimer.start()
	$EndDropTimer.start()
	$ColorRect/ColorAnimPlayer.play("color_change")


func _on_ball_bug():
	$TooFastTimer.start()
	$TooFast.show()


func _on_too_fast_timer_timeout():
	$TooFast.hide()
	if is_player:
		reset_ball.emit(true)
	else:
		reset_ball.emit(false)


func _on_ball_position_for_wind(velocity):
	if (velocity.x >= -0.5 and velocity.x <= 0):
		wind_velocity.x = -0.2
	elif (velocity.x <= 0.5 and velocity.x >= 0):
		wind_velocity.x = 0.2

	elif (velocity.y >= -0.5 and velocity.y <= 0):
		wind_velocity.y = -0.2
	elif (velocity.y <= 0.5 and velocity.y >= 0):
			wind_velocity.y = 0.2
	if velocity != Vector2.ZERO and wind_velocity != Vector2.ZERO:
		$WindTimer.start()
		$WindIncoming.show()


func _on_wind_timer_timeout():
	$WindIncoming.hide()
	wind_init.emit(wind_velocity)
