class_name Room extends Node2D

@onready var main_load     : PackedScene = preload("res://rooms/main_sceen/main.tscn");
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene();
	if event.is_action_pressed("menu"):
		BackgroundMusic.stop_music();
		get_tree().change_scene_to_packed(main_load);
