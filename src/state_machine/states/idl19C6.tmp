extends State

@export var walk : State;
@export var falling : State;

func state_name():
	return "idle";

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
		return falling;
	
	if Input.get_axis("left", "right"):
		return walk;
	
	actor.update_position();
	return null;
