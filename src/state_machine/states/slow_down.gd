extends State

@export var idle : State;
@export var falling : State;

var tw : Tween;

func state_name():
	return "slow_down";

func enter() -> void:
	tw = create_tween();
	tw.tween_property(actor, "scale", Vector2(1, 1), 0.1);
	tw.tween_property(actor, "scale", Vector2(1.1, 1.), 0.2);

func exit() -> void:
	tw.kill();

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		actor.jump();
		actor.update_position();
		return falling
	if !actor.is_on_floor():
		return falling;
	
	actor.velocity.x = lerp(actor.velocity.x, 0., pow(0.3, delta));
	if abs(actor.velocity.x) <= 0.01:
		actor.velocity.x = 0;
		return idle;
	
	actor.update_position();
	return null;
