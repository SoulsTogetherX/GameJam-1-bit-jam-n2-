extends Node2D

var tween : Tween = null;
var input_accept : bool = false;

var room_1_load : PackedScene = preload("res://rooms/puzzel_rooms/1/room_1.tscn");
var main_screen_load : PackedScene = preload("res://rooms/main_sceen/main.tscn");

@onready var reached: Label = $MarginContainer/VBoxContainer/reached
@onready var orbs: Label = $MarginContainer/VBoxContainer/orbs;
@onready var time: Label = $MarginContainer/VBoxContainer/time;
@onready var main: Label = $MarginContainer/VBoxContainer/main;
@onready var play: Label = $MarginContainer/VBoxContainer/play;

@onready var check_1: Sprite2D = $Check_1;
@onready var secret: Node2D = $Secret

func format_collected(collected : int) -> void:
	orbs.text = "             Orbs Collected : %02d / %02d" % [collected, (GlobalStuff.total_bonuses - 1)];

func format_time(time_ms : int) -> void:
	var seconds     : int  = int(time_ms / 1000);
	var minutes     : int  =  int(seconds / 60.0);
	var hours       : int  =  int(minutes / 3600.0);
	
	time.text = "            Time Taken : %02d:%02d:%02d.%03d" % [hours, minutes % 60, seconds % 60, time_ms % 1000]

func _enter_tree() -> void:
	GlobalStuff.end_time = Time.get_ticks_msec();

func _rotate_check(check : Sprite2D, time : float) -> void:
	check.visible = true;
	var otherTween = create_tween();
	otherTween.tween_interval(0.1);
	otherTween.set_trans(Tween.TRANS_ELASTIC);
	otherTween.set_ease(Tween.EASE_OUT);
	otherTween.tween_property(check,  "rotation", 0, time);
	
	await otherTween.finished;
	otherTween.kill();

func _place_secret() -> void:
	var otherTween = create_tween();
	otherTween.set_trans(Tween.TRANS_SINE);
	otherTween.set_ease(Tween.EASE_OUT);
	otherTween.tween_property(secret,  "position:y", 80, 2.);
	
	await otherTween.finished;
	otherTween.kill();

func _ready() -> void:
	BackgroundMusic.fade_out(2.0, -80);
	
	$falling_girl/main.flip_h = GlobalStuff.playerDirEnd;
	$falling_girl/main/fade.flip_h = GlobalStuff.playerDirEnd;
	if GlobalStuff.playerDirEnd:
		$falling_girl.position.x = 400;
		secret.position.x = 400;
		$New_Options.position.x = 328;
	
	$background_1.modulate.a = 0.0;
	reached.modulate.a       = 0.0;
	orbs.modulate.a          = 0.0;
	time.modulate.a          = 0.0;
	main.modulate.a          = 0.0;
	play.modulate.a          = 0.0;
	check_1.modulate.a       = 0.0;
	
	var max_collected        = GlobalStuff.collected_bonuses();
	var max_time_ms          = GlobalStuff.get_time_ms();
	
	tween = create_tween();
	tween.tween_interval(3.5);
	tween.tween_callback(func(): input_accept = true);
	tween.tween_property($background_1, "modulate:a", 0.0705882, 1.0);
	tween.parallel().tween_property(reached, "modulate:a", 1.0, 1.0);
	tween.tween_interval(0.5);
	
	tween.tween_property(orbs, "modulate:a", 1.0, 2.0);
	tween.tween_callback(format_collected.bind(0));
	tween.tween_property(orbs, "visible_characters", 37, 0.25);
	tween.tween_method(format_collected, 0, max_collected, 0.05 * max_collected);
	
	if max_collected >= 10:
		tween.tween_property(check_1,  "modulate:a", 1.0, 1.0);
		tween.parallel().tween_callback(_rotate_check.bind(check_1, 1.));
		if max_collected >= 11:
			GlobalStuff.can_dapper = true;
			$falling_girl/main/CPUParticles2D.modulate.a = 0.0;
			tween.parallel().tween_callback(_rotate_check.bind($Check_2, 2.0));
			tween.tween_callback(_place_secret);
	
	tween.tween_interval(0.1);
	tween.tween_property(time, "modulate:a", 1.0, 2.0);
	tween.tween_callback(format_time.bind(0));
	tween.tween_property(time, "visible_characters", 37, 0.5);
	tween.tween_method(format_time, 0, max_time_ms, 2.0);
	
	tween.tween_property(main, "modulate:a", 1.0, 2.0);
	tween.parallel().tween_property(play, "modulate:a", 1.0, 2.0);	
	
	await tween.finished;
	if max_collected < 11:
		tween.kill();
		
		tween = create_tween();
		tween.tween_property($falling_girl, "position:y", 700, 256);
		
		return;
	
	$falling_girl.collision_mask = 1;
	$falling_girl.process_mode = Node.PROCESS_MODE_INHERIT;

func _transition():
	tween.kill();
	GlobalStuff.reset_collected();

func _input(event: InputEvent) -> void:
	if input_accept:
		if event.is_action_pressed("restart"):
			_transition();
			
			var tw : Tween = create_tween();
			tw.tween_property(self, "modulate:a", 0.0, 1.0);
			await tw.finished;
			tw.kill();
			
			get_tree().change_scene_to_packed(room_1_load);
		elif event.is_action_pressed("menu"):
			_transition();
			
			var tw : Tween = create_tween();
			tw.tween_property(self, "modulate:a", 0.0, 1.0);
			await tw.finished;
			tw.kill();
			
			get_tree().change_scene_to_packed(main_screen_load);
