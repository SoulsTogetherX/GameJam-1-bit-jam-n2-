extends Sprite2D

var tween : Tween = null;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Player:
		return;
	
	if tween != null:
		await tween.finished;
	
	tween = create_tween();
	tween.set_trans(Tween.TRANS_SINE);
	tween.tween_property(self, "modulate:a", 0, 0.2);
	
	await tween.finished;
	tween.kill();


func _on_area_2d_body_exited(body: Node2D) -> void:
	if not body is Player:
		return;
	
	if tween != null:
		await tween.finished;
	
	tween = create_tween();
	tween.set_trans(Tween.TRANS_SINE);
	tween.tween_property(self, "modulate:a", 1.0, 0.2);
	
	await tween.finished;
	tween.kill();
