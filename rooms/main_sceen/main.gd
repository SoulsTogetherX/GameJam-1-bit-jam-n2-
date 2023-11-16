extends Node2D

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://rooms/puzzel_rooms/1/room_1.tscn");

func _on_quit_pressed() -> void:
	get_tree().quit();

func _on_credits_pressed() -> void:
	pass # Replace with function body.
