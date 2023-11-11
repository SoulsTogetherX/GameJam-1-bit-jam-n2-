extends State

@export var idle : State;

const HOLD_OFFSET = Vector2(0, 30);

func state_name():
	return "selecting";

func enter() -> void:
	for held in actor._holding:
		held.hold();
		GlobalStuff.swap_parent(held, self);

func exit() -> void:
	for held in actor._holding:
		held.drop();
	actor._holding.clear();

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		return idle;
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(_delta: float) -> State:
	actor._cam.update_position();
	return null;
