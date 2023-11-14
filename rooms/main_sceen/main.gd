extends Node2D

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://rooms/puzzel_rooms/1/room_1.tscn");
