extends State

@export var slowDown : State;
@export var jumping : State;
@export var falling : State;

@onready var push: CollisionShape2D = $"../../../push"
@onready var normal: CollisionShape2D = $"../../../normal"

@onready var time : Timer = $Timer;
@onready var push_area : Area2D = $"../../../Area2D";
var tw : Tween;

func state_name():
	return "push";

func enter() -> void:
	push.disabled   = false;
	normal.disabled = true;
	
	tw = create_tween();
	tw.tween_property(actor.get_node("tweener"), "scale", Vector2(1, 1), 0.1);
	actor.animation_player.play("push");
	actor.turn(actor.velocity.x < 0);

func exit() -> void:
	push.disabled   = true;
	normal.disabled = false;
	tw.kill();

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(delta: float) -> State:
	var bods = push_area.get_overlapping_bodies();
	if bods.size() == 0:
		return slowDown;
	
	var direction = Input.get_axis("left", "right");
	if direction == 0:
		actor.animation_player.stop(false);
	else:
		actor.turn(direction == -1);
		if !actor.animation_player.is_playing():
			actor.animation_player.play();
	
	actor.velocity.x = direction * actor.SPEED;
	
	for bod in bods:
		if bod is RigidBody2D:
			bod.apply_central_impulse(Vector2(actor.velocity.x, 0).normalized() * actor.PUSH_FORCE);
	
	if Input.is_action_just_pressed("jump"):
		return jumping
	if !actor.is_on_floor():
		return falling;
	
	actor.update_position();
	
	return null;
