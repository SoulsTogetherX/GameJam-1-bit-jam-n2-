extends Node2D

func _ready() -> void:
	var tw = create_tween().set_loops();
	var dir = sign(randf() - 0.5);
	if dir == 0:
		dir = 1;
	tw.set_trans(Tween.TRANS_SINE);
	tw.tween_property(self, "position:y", 5 * scale.y *  dir + position.y, 0.5);
	tw.tween_property(self, "position:y", 5 * scale.y * -dir + position.y, 0.5);
	tw.play();
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		var tw = create_tween();
		tw.set_trans(Tween.TRANS_SINE);
		tw.tween_property(self, "modulate:a", 0, 0.2);
		
		await tw.finished;
		tw.kill();


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		var tw = create_tween();
		tw.set_trans(Tween.TRANS_SINE);
		tw.tween_property(self, "modulate:a", 1.0, 0.2);
		
		await tw.finished;
		tw.kill();
