extends CharacterBody2D

@onready var at : Vector2 = position;
@export var move_to : Vector2;
@export var move_to_spd   : int;
@export var move_back_spd : int;

@export var disabled: bool = false:
	set(val):
		disabled = val;
		stop = false;
var stop : bool = false;
@export var up: bool = false;

var player : Player = null;

func _ready() -> void:
	move_to += position;

func _physics_process(delta: float) -> void:
	if stop:
		return;
	
	if disabled:
		var vec = (at - position);
		velocity = vec.normalized() * min(vec.length() / delta, move_back_spd);
		collision_mask = 1 + (6 * int(up));
	else:
		var vec = (move_to - position);
		velocity = vec.normalized() * min(vec.length() / delta, move_to_spd);
		collision_mask = 1 + (6 * int(!up));
	
	if player != null && !player._jumping:
		player.velocity = velocity * 0.5;
		player.update_position();
	move_and_slide();
	if get_slide_collision_count() > 0:
		stop = true;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body;

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null;
