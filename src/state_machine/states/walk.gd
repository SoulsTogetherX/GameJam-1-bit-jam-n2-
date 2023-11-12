extends State

@export var slowDown : State;
@export var falling : State;

var tw : Tween;

func state_name():
	return "walk";

func enter() -> void:
	tw = create_tween();
	tw.tween_property(actor, "scale", Vector2(1, 1), 0.1);
	tw.tween_property(actor, "scale", Vector2(1.1, 1.), 0.2);

func exit() -> void:
	actor.wall_steps.emitting = false;
	tw.kill();

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(_delta: float) -> State:
	var direction = Input.get_axis("left", "right");
	if !direction:
		return slowDown;
	
	actor.velocity.x = direction * actor.SPEED;
	
	if actor.velocity.x == 0:
		actor.wall_steps.emitting = false;
	else:
		actor.wall_steps.emitting = true;
		actor.wall_steps.direction.x = -sign(actor.velocity.x);
	
	if Input.is_action_just_pressed("jump"):
		actor.jump();
		actor.update_position();
		return falling
	if !actor.is_on_floor():
		return falling;
	
	actor.update_position();
	
	return null;
