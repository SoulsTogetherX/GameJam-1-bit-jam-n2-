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
	ani_tween.tween_property(self, "scale", Vector2(2.05, 2.05), 2);
	ani_tween.tween_property(self, "scale", Vector2(1.95, 1.95), 2);
	ani_tween.play();

var collect_particles = preload("res://assets/particles/collect_particle.tscn");
func collected():
	if fin_tween != null:
		return;
	
	BackgroundMusic.fade_out_and_in(0.5, 3.6, 1.5, -10.0);
	
	ani_tween.kill();
	BackgroundMusic.play_found_efx($AudioStreamPlayer, null, 10);
	GlobalStuff.bonuses_collected[room_num] = true;
	$Label.text = GlobalStuff.collected_formated();
	
	fin_tween = create_tween(); 
	fin_tween.set_ease(Tween.EASE_OUT).set_parallel();
	fin_tween.tween_property(self, "modulate:a", 0.0, 3.5);
	
	fin_tween.tween_property($sprite1, "modulate:a", 0.0, 3.5);
	fin_tween.tween_property($sprite1, "scale", Vector2(5, 5), 3.5);
	fin_tween.tween_property($sprite2, "modulate:a", 0.0, 2.33333);
	fin_tween.tween_property($sprite2, "scale", Vector2(6.25, 6.25), 3.5);
	fin_tween.tween_property($sprite3, "modulate:a", 0.0, 1.16667);
	fin_tween.tween_property($sprite3, "scale", Vector2(7.5, 7.5), 3.5);
	
	fin_tween.tween_property($Label, "modulate:a", 1.0, 2.5);
	fin_tween.tween_property($Label, "position:y", -200.0, 3.5);
	
	var part = collect_particles.instantiate();
	add_sibling(part);
	part.position = position;
	
	await fin_tween.finished;
	fin_tween.kill();
	queue_free();

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		collected();
