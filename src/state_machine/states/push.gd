extends State

@export var idle : State;
@export var falling : State;

@onready var time : Timer = $Timer;
@onready var push_area : Area2D = $"../../../Area2D";
var tw : Tween;

func state_name():
	return "push";

func enter() -> void:
	tw = create_tween();
	tw.tween_property(actor, "scale", Vector2(1, 1), 0.1);
	time.start();

func exit() -> void:
	tw.kill();
	time.stop();

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(delta: float) -> State:
	var bods = push_area.get_overlapping_bodies();
	if bods.size() == 0:
		return idle;
	
	var direction = Input.get_axis("left", "right");
	actor.velocity.x = direction * actor.SPEED;
	
	for bod in bods:
		if bod.owner is RigidBody2D:
			bod.owner.apply_central_impulse(Vector2(actor.velocity.x, 0).normalized() * actor.PUSH_FORCE);
	
	if Input.is_action_just_pressed("jump"):
		actor.jump();
		actor.update_position();
		return falling
	if !actor.is_on_floor():
		return falling;
	
	actor.update_position();
	
	return null;

func _on_timer_timeout() -> void:
	actor.wall_steps.play(-sign(actor.velocity.x));