extends CharacterBody2D

@onready var at : Vector2 = position;
@export var move_to : Vector2;
@export var move_to_spd   : int;
@export var move_back_spd : int;

@export var override : bool = false;

@export var disabled: bool = false:
	set(val):
		disabled = val;
		stop = false;
var stop : bool = false;
@export var up: bool = false;

var player : Player = null;
var top_collide : int;

func _ready() -> void:
	move_to += position;
	top_collide = collision_mask & ~1;

func _physics_process(delta: float) -> void:
	if stop:
		return;
	
	if disabled:
		var vec = (at - position);
		velocity = vec.normalized() * min(vec.length() / delta, move_back_spd);
		collision_mask = 1 + (top_collide * int(up || override));
	else:
		var vec = (move_to - position);
		velocity = vec.normalized() * min(vec.length() / delta, move_to_spd);
		collision_mask = 1 + (top_collide * int(!up || override));
	
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
