extends AnimatableBody2D

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
var velocity : Vector2;

func _ready() -> void:
	move_to += position;
	top_collide = collision_mask & ~1;

func _physics_process(delta: float) -> void:
	if stop:
		return;
	
	if disabled:
		var vec = (at - position);
		velocity = vec.normalized() * min(vec.length() / delta, move_back_spd);
		if !override:
			collision_mask = 1 + (top_collide * int(up));
	else:
		var vec = (move_to - position);
		velocity = vec.normalized() * min(vec.length() / delta, move_to_spd);
		if !override:
			collision_mask = 1 + (top_collide * int(!up));
	
	if velocity.length_squared() > 0:
		BackgroundMusic.play_found_efx($AudioStreamPlayer2D, null, 15);
	else:
		$AudioStreamPlayer2D.stop();
	
	var collision = move_and_collide(velocity * delta);
	if collision != null:
		var a = collision.get_angle(velocity.normalized());
		if PI/2 < a && a < 3*PI/2:
			stop = true;
			$AudioStreamPlayer2D.stop();
			return;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body;

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null;
