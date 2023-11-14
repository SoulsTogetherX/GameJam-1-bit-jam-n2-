extends State

@export var slowDown : State;
@export var falling : State;

@onready var time : Timer = $Timer;
var tw : Tween;

func state_name():
	return "walk";

func enter() -> void:
	tw = create_tween();
	tw.tween_property(actor, "scale", Vector2(1, 1), 0.1);
	tw.tween_property(actor, "scale", Vector2(1.1, 1.), 0.2);
	time.start();

func exit() -> void:
	tw.kill();
	time.stop();

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(_delta: float) -> State:
	var direction = Input.get_axis("left", "right");
	if !direction:
		return slowDown;
	
	actor.velocity.x = direction * actor.SPEED;
	
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
