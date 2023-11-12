extends CharacterBody2D

@onready var at : Vector2 = position;
@export var move_to : Vector2;
@export var move_to_spd   : int;
@export var move_back_spd : int;

@export var disabled: bool = false;
@export var up: bool = false;

func _ready() -> void:
	move_to += position;

func _physics_process(delta: float) -> void:
	if disabled:
		var vec = (at - position);
		velocity = vec.normalized() * min(vec.length() / delta, move_back_spd);
		collision_mask = 1 + (6 * int(up));
	else:
		var vec = (move_to - position);
		velocity = vec.normalized() * min(vec.length() / delta, move_to_spd);
		collision_mask = 1 + (6 * int(!up));
	move_and_slide()
