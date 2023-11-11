extends State

@export var slowDown : State;
@export var falling : State;

func state_name():
	return "walk";

func enter() -> void:
	pass;

func exit() -> void:
	pass;

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
