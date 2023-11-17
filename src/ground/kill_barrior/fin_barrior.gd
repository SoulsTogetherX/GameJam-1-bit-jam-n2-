extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	var tw = create_tween();
	tw.tween_property($"../player", "modulate:a", 0.0, 1.5);
	await tw.finished;
	
	GlobalStuff.playerDirEnd = $"../player/tweener/main".flip_h;
	
	get_tree().change_scene_to_file("res://rooms/end_screen/end.tscn");
