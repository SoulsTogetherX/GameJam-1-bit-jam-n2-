class_name Room extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		Segment.mouse_full = false;
		get_tree().reload_current_scene();
