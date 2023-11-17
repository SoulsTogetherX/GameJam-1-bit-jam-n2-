class_name DoorActions extends Node

@warning_ignore("unused_parameter")
@onready var _door     : Door = get_parent();

@export var fade_time : float = 0.5;
@export_file("*.tscn") var _nextRoom;
var _every : Every;
var _thing : Thing;
var _no    : No;
var _player: Player;

signal objective;
signal objective_undo;
signal attached;

func _ready() -> void:
	connect("objective", _on_objective);
	connect("objective_undo", _on_objective_undo);
	connect("attached", _on_thing_attached);
	var tw = create_tween().set_parallel();
	for c in owner.get_children():
		if c is Every:
			_every = c
			if _every.pause:
				_every.modulate.a = 0.7;
		elif c is Thing:
			_thing = c
			if _thing.pause:
				_thing.modulate.a = 0.7;
		elif c is No:
			_no = c
			if _no.pause:
				_no.modulate.a = 0.7;
		elif c is Player:
			_player = c
		tw.tween_property(c, "modulate:a", c.modulate.a, fade_time);
		
		c.modulate.a = 0.;
	tw.chain().tween_callback(func():
		_player.state_contr.force_change_state("idle");
		)

func _on_thing_attached() -> void:
	pass;

func _on_objective_undo() -> void:
	pass;

func _on_objective() -> void:
	pass;

func action(state : Door.STATE):
	match state:
		Door.STATE.LOCKED:
			on_locked();
		Door.STATE.OPEN:
			on_open();
		Door.STATE.CLOSED:
			on_closed();

func on_locked():
	pass;

func on_open():
	_player.end_room_hide();
	var tw = create_tween().set_parallel();
	
	for c in get_tree().current_scene.get_children():
		tw.tween_property(c, "modulate:a", 0.0, randf_range(0.3,3.));
	
	tw.chain().tween_interval(0.5);
	await tw.finished;
	
	_player.queue_free();
	get_tree().change_scene_to_file(_nextRoom);

func on_closed():
	pass;
