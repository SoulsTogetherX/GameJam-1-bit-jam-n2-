extends Node2D

@onready var music_slide   : HSlider = $MarginContainer/VBoxContainer/MarginContainer2/PanelContainer/Panel/Music/MarginContainer2/music_slide;
@onready var sfx_slide     : HSlider = $MarginContainer/VBoxContainer/MarginContainer3/PanelContainer/Panel/Music/MarginContainer2/sfx_slide;

@onready var main_load     : PackedScene = preload("res://rooms/main_sceen/main.tscn");
@onready var options_sound : Resource    = load("res://assets/sound/button/Options_Back.wav");

func _ready() -> void:
	music_slide.value = BackgroundMusic.music_volume;
	sfx_slide.value   = BackgroundMusic.sfx_volume;
	
	if GlobalStuff.can_dapper:
		$dapper.visible = true;

func button_flicker(button : Button) -> Tween:
	var tw = create_tween();
	tw.set_trans(Tween.TRANS_SINE);
	tw.tween_property(button , "modulate:a", 0.2, 0.1);
	tw.tween_property(button , "modulate:a", 0.6, 0.1);
	
	return tw;

func _on_back_pressed() -> void:
	BackgroundMusic.set_volume(music_slide.value);
	BackgroundMusic.sfx_volume = sfx_slide.value;
	BackgroundMusic.play_found_efx($AudioStreamPlayer, options_sound);
	
	var tween = button_flicker($back);
	await $AudioStreamPlayer.finished;
	tween.kill();
	
	get_tree().change_scene_to_packed(main_load);

func _on_dapper_pressed() -> void:
	GlobalStuff.dapper = !GlobalStuff.dapper;
	$dapper_sprite.visible = GlobalStuff.dapper;

func _slide_drag_ended(value_changed: bool) -> void:
	BackgroundMusic.sfx_volume = sfx_slide.value;
	BackgroundMusic.play_found_efx($AudioStreamPlayer, options_sound);
