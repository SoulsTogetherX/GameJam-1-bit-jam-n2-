@tool
extends Node2D

const _SPRITES = [
	preload("res://assets/sprites/door/cross.png"),
	preload("res://assets/sprites/door/door_open.png"),
	preload("res://assets/sprites/door/door_close.png"),
]

enum STATE {LOCKED, OPEN, CLOSED};
@export var state : STATE = STATE.CLOSED:
	set(val):
		state = val;
		match val:
			STATE.LOCKED:
				lock();
			STATE.OPEN:
				open();
			STATE.CLOSED:
				close();

@onready var _lock_spr : Sprite2D = $lock;
@onready var _door_spr : Sprite2D = $regular;

func lock():
	_lock_spr.visible = true;
	_door_spr.texture = _SPRITES[2];

func open():
	_lock_spr.visible = false;
	_door_spr.texture = _SPRITES[1];

func close():
	_lock_spr.visible = false;
	_door_spr.texture = _SPRITES[2];
