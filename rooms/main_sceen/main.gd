extends Node2D

@onready var image: TextureRect = $image
@onready var title: Label = $Label
@onready var margin_container: MarginContainer = $MarginContainer

@onready var play_load     : PackedScene = load("res://rooms/puzzel_rooms/1/room_1.tscn");
@onready var options_load  : PackedScene = load("res://rooms/options_screen/options.tscn");
@onready var credits_load  : PackedScene = load("res://rooms/credits_screen/credits.tscn");

@onready var play_sound    : Resource = load("res://assets/sound/button/Play.wav");
@onready var quit_sound    : Resource = load("res://assets/sound/button/Quit.wav");
@onready var options_sound : Resource = load("res://assets/sound/button/Options_Back.wav");
@onready var credits_sound : Resource = load("res://assets/sound/button/Credits_Back.wav");

func _ready() -> void:
	modulate.a = 0.0;
	var tw : Tween = create_tween();
	tw.tween_property(self, "modulate:a", 1.0, 1.0);
	tw.set_trans(Tween.TRANS_CUBIC);
	tw.set_trans(Tween.TRANS_SINE);
	tw.set_trans(Tween.TRANS_CIRC);
	tw.set_trans(Tween.TRANS_QUINT);
	tw.tween_property(image, "position:x", -576, 0.5);
	tw.set_parallel().tween_interval(0.2);
	tw.tween_property(margin_container, "theme_override_constants/margin_left", 200, 0.5);
	tw.tween_property(margin_container, "theme_override_constants/margin_right", 600, 0.5);

func button_flicker(button : Button) -> Tween:
	var tw = create_tween();
	tw.set_trans(Tween.TRANS_SINE);
	tw.tween_property(button , "modulate:a", 0.2, 0.1);
	tw.tween_property(button , "modulate:a", 0.6, 0.1);
	
	return tw;

static var music = preload("res://assets/music/1-bit.mp3");
func _on_play_pressed() -> void:
	BackgroundMusic.play_found_efx($AudioStreamPlayer, play_sound);
	
	var tween = button_flicker($MarginContainer/buttons/play);
	await $AudioStreamPlayer.finished;
	tween.kill();
	
	GlobalStuff.start_time = Time.get_ticks_msec();
	BackgroundMusic.stop();
	
	print(music);
	print(BackgroundMusic.playing);
	BackgroundMusic.set_music(music);
	BackgroundMusic.position = 0.0;
	BackgroundMusic.play_music();
	
	get_tree().change_scene_to_packed(play_load);

func _on_quit_pressed() -> void:
	BackgroundMusic.play_found_efx($AudioStreamPlayer, quit_sound);
	
	var tween = button_flicker($MarginContainer/buttons/quit);
	await $AudioStreamPlayer.finished;
	tween.kill();
	
	get_tree().quit();

func _on_option_pressed() -> void:
	BackgroundMusic.play_found_efx($AudioStreamPlayer, options_sound);
	
	var tween = button_flicker($MarginContainer/buttons/option);
	await $AudioStreamPlayer.finished;
	tween.kill();
	
	get_tree().change_scene_to_packed(options_load);

func _on_credits_pressed() -> void:
	BackgroundMusic.play_found_efx($AudioStreamPlayer, credits_sound);
	
	var tween = button_flicker($MarginContainer/buttons/credits);
	await $AudioStreamPlayer.finished;
	tween.kill();
	
	get_tree().change_scene_to_packed(credits_load);
