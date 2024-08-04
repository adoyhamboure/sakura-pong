extends CanvasLayer

signal start
var animation_duration = 0.5

func _ready():
	$HBoxContainer.position = Vector2(410.5, 1500)
	$Title/TitleAnimPlayer.play("bounce")
	$VBoxContainer/BoxAnimPlayer.play("bounce")
	$Eyes/EyesAnimPlayer.play("bounce")
	$Eyes.text = 'n'
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -15.0)
	$Options/VolumeSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) + 80
	$DifficultyLabel/DifficultyAnimPlayer.play("bounce")
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
		# Assurez-vous que le tween est arrêté avant de lancer une nouvelle animation
	var tween = get_tree().create_tween()
	# Interpolation de la position
	tween.tween_property($VBoxContainer, "position", Vector2(250, 2000), animation_duration)
	tween.tween_property($Title, "position", Vector2(616, -250), animation_duration)
	tween.tween_property($Eyes, "position", Vector2(2500, 196), animation_duration)
	tween.tween_property($DifficultyLabel, "position", Vector2(225.5, 300), animation_duration)	
	tween.tween_property($HBoxContainer, "position", Vector2(410.5, 700), animation_duration)
	tween.tween_callback(_start_difficulties_animations)
	tween.tween_property($ReturnButton, "position", Vector2(125, 130), animation_duration)	
	$HBoxContainer/Easy.grab_focus()

func _start_difficulties_animations():
	$HBoxContainer/HBoxAnimPlayer.play("bounce")

func start_game():
	start.emit()


func _on_quit_button_pressed():
	# Quit the game
	get_tree().quit()


func _on_start_button_mouse_entered():
	$Eyes.text = 'e'


func _on_quit_button_mouse_entered():
	$Eyes.text = 'h'


func _reset_eyes():
	$Eyes.text = 'n'


func _on_eyes_mouse_entered():
	$Eyes.text = 'k'


func _on_title_mouse_entered():
	$Eyes.text = 'y'


func _on_option_button_mouse_entered():
	$Eyes.text = 'u'


func _on_option_button_pressed():
	$Options/VolumeSlider.grab_focus()
	_move_containers()
	
func _move_containers():
	# Assurez-vous que le tween est arrêté avant de lancer une nouvelle animation
	var tween = get_tree().create_tween()
	# Interpolation de la position
	tween.tween_property($VBoxContainer, "position", Vector2(-800, 600), animation_duration)
	tween.tween_property($Options, "position", Vector2(250, 600), animation_duration)

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value - 80)


func _on_go_back_button_pressed():
	$VBoxContainer/StartButton.grab_focus()
	_move_back_containers()

func _move_back_containers():
	# Assurez-vous que le tween est arrêté avant de lancer une nouvelle animation
	var tween = get_tree().create_tween()
	# Interpolation de la position
	tween.tween_property($Options, "position", Vector2(250, 1200), animation_duration)	
	tween.tween_property($VBoxContainer, "position", Vector2(250, 600), animation_duration)


func _on_easy_pressed():
	Global.difficulty = 'easy'
	start_game()


func _on_normal_pressed():
	Global.difficulty = 'normal'
	start_game()	


func _on_impossible_pressed():
	Global.difficulty = 'impossible'
	start_game()	


func _on_return_button_pressed():
	$VBoxContainer/StartButton.grab_focus()
	$HBoxContainer/HBoxAnimPlayer.stop()
	var tween = get_tree().create_tween()
	# Interpolation de la position
	tween.tween_property($ReturnButton, "position", Vector2(-300, 130), animation_duration)
	tween.tween_property($HBoxContainer, "position", Vector2(410.5, 1500), animation_duration)
	tween.tween_property($DifficultyLabel, "position", Vector2(225.5, -300), animation_duration)
	tween.tween_property($Title, "position", Vector2(616, 167), animation_duration)
	tween.tween_property($Eyes, "position", Vector2(1132, 196), animation_duration)
	tween.tween_property($VBoxContainer, "position", Vector2(250, 600), animation_duration)
