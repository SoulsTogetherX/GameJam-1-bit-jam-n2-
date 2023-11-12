extends State

@export var idle : State;
@export var falling : State;

func state_name():
	return "slow_down";

func enter() -> void:
	pass;

func exit() -> void:
	pass;

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(_delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		actor.jump();
		actor.update_position();
		return falling
	if !actor.is_on_floor():
		return falling;
	
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED);
	if actor.velocity.x == 0:
		return idle;
	
	actor.update_position();
	return null;
