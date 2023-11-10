@tool
class_name Door extends Node2D

const _SPRITES = [
	preload("res://assets/sprites/door/cross.png"),
	preload("res://assets/sprites/door/door_open.png"),
	preload("res://assets/sprites/door/door_close.png"),
]

enum STATE {LOCKED, OPEN, CLOSED};
var _state = STATE.LOCKED;
@export var state : STATE:
	get:
		return _state;
	set(val):
		if isReady:
			_set_state(val);
		else:
			_state = val;

@onready var _lock_spr   : Sprite2D = $lock;
@onready var _door_spr   : Sprite2D = $regular;
@onready var _get_action : Node     = $action;
var isReady : bool = false;

func _ready() -> void:
	_set_state(_state);
	isReady = true;

func _set_state(st : STATE) -> void:
	match st:
		STATE.LOCKED:
			lock();
		STATE.OPEN:
			open();
		STATE.CLOSED:
			close();

func lock() -> void:
	_state = STATE.LOCKED;
	_lock_spr.visible = true;
	_door_spr.texture = _SPRITES[2];

func open() -> void:
	_state = STATE.OPEN;
	_lock_spr.visible = false;
	_door_spr.texture = _SPRITES[1];

func close() -> void:
	_state = STATE.CLOSED;
	_lock_spr.visible = false;
	_door_spr.texture = _SPRITES[2];

func lockAnimation() -> void:
	var tween = create_tween().parallel().set_loops(2);
	tween.tween_property(_lock_spr, "rotation_degrees", -2, 0.1);
	tween.tween_property(_lock_spr, "rotation_degrees", 2, 0.1);
	await tween.finished;
	tween.kill();

func action():
	_get_action.action(state);
