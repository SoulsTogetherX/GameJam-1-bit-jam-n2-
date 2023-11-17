extends Node2D

@onready var main_load    : PackedScene = preload("res://rooms/main_sceen/main.tscn");
@onready var credits_sound : Resource = load("res://assets/sound/button/Credits_Back.wav");

func button_flicker(button : Button) -> Tween:
	var tw = create_tween();
	tw.set_trans(Tween.TRANS_SINE);
	tw.tween_property(button , "modulate:a", 0.2, 0.1);
	tw.tween_property(button , "modulate:a", 0.6, 0.1);
	
	return tw;

func _on_back_pressed() -> void:
	BackgroundMusic.play_found_efx($AudioStreamPlayer, credits_sound);
	
	var tween = button_flicker($back);
	await $AudioStreamPlayer.finished;
	tween.kill();
	
	get_tree().change_scene_to_packed(main_load);
