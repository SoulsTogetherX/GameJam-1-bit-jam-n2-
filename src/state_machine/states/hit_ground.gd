extends State

@export var falling : State;
@export var idle : State;

var tw : Tween;
var canExit : bool = false;
var fall_height : float;

func state_name():
	return "hit ground";

func enter() -> void:
	tw = create_tween();
	if fall_height < 10:
		canExit = true;
		return;
	
	canExit = false;
	actor.coyote_timer.start();
	tw.tween_property(actor, "scale", Vector2(1.15, 1.), 0.1);
	tw.tween_property(actor, "scale", Vector2(1., 1.), 0.1);
	tw.tween_callback(func(): canExit = true);
	print(canExit)

func exit() -> void:
	tw.kill();

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		actor.jump();
		return falling;
	
	if canExit:
		return idle;
	return null;

func process_physics(delta: float) -> State:
	return null;
