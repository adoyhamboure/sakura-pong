extends Node

var simultaneous_scene = preload("res://scenes/main.tscn").instantiate()
var last_mouse_pos = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuMusic.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MainMenuHUD/CPUParticles2D2.position = get_viewport().get_mouse_position()
	if last_mouse_pos != get_viewport().get_mouse_position():
		$MainMenuHUD/CPUParticles2D2.emitting = true
	else:
		$MainMenuHUD/CPUParticles2D2.emitting = false
		
	last_mouse_pos = get_viewport().get_mouse_position()


func _on_main_menu_hud_start():
	var tween = get_tree().create_tween()
	# Interpolation de la position
	tween.tween_property($MenuMusic, "volume_db", -80, 1)
	tween.tween_callback(change_scene)

func change_scene():
	get_tree().root.add_child(simultaneous_scene)
	queue_free()
