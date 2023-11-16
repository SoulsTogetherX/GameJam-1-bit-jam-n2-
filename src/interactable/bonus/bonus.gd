extends Node2D

@export var room_num = 0;
var fin_tween : Tween = null;
var ani_tween : Tween = null;

func _ready() -> void:
	if GlobalStuff.bonuses_collected[room_num] == true:
		queue_free();
		return;
	
	var tw = create_tween().set_loops();
	var dir = sign(randf() - 0.5);
	if dir == 0:
		dir = 1;
	tw.set_trans(Tween.TRANS_SINE);
	tw.tween_property(self, "position:y", 2 * scale.y *  dir + position.y, 1.2);
	tw.tween_property(self, "position:y", 2 * scale.y * -dir + position.y, 1.2);
	tw.play();
	
	ani_tween = create_tween().set_loops();
	ani_tween.set_trans(Tween.TRANS_CUBIC);
	ani_tween.tween_property(self, "scale", Vector2(1.05, 1.05), 2);
	ani_tween.tween_property(self, "scale", Vector2(0.95, 0.95), 2);
	ani_tween.play();

var collect_particles = preload("res://assets/particles/collect_particle.tscn");
func collected():
	if fin_tween != null:
		return;
	
	ani_tween.kill();
	$AudioStreamPlayer.play();
	GlobalStuff.bonuses_collected[room_num] = true;
	$Label.text =  str(GlobalStuff.collected_bonuses()) + " / " + str(GlobalStuff.total_bonuses);
	
	fin_tween = create_tween(); 
	fin_tween.set_ease(Tween.EASE_OUT).set_parallel();
	fin_tween.tween_property(self, "modulate:a", 0.0, 3.5);
	
	fin_tween.tween_property($sprite1, "modulate:a", 0.0, 3.5);
	fin_tween.tween_property($sprite1, "scale", Vector2(2.0, 2.0), 3.5);
	fin_tween.tween_property($sprite2, "modulate:a", 0.0, 2.33333);
	fin_tween.tween_property($sprite2, "scale", Vector2(2.5, 2.5), 3.5);
	fin_tween.tween_property($sprite3, "modulate:a", 0.0, 1.16667);
	fin_tween.tween_property($sprite3, "scale", Vector2(3.0, 3.0), 3.5);
	
	fin_tween.tween_property($Label, "modulate:a", 1.0, 2.5);
	fin_tween.tween_property($Label, "position:y", -20, 3.5);
	
	var part = collect_particles.instantiate();
	add_sibling(part);
	part.position = position;
	
	await fin_tween.finished;
	fin_tween.kill();
	queue_free();

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		collected();
