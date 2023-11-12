extends State

@export var walking : State;
@export var idle : State;

var tw : Tween;

func state_name():
	return "falling";

func enter() -> void:
	actor.coyote_timer.start();
	tw = create_tween();
	tw.tween_property(actor, "scale", Vector2(1, 1.2), 0.1);

func exit() -> void:
	actor.velocity.y = 0;
	actor._jumping = false;
	tw.kill();

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		if actor.coyote_timer.is_stopped():
			actor.jump_buffer.start();
		else:
			actor.jump();
	
	actor.velocity.y += actor.GRAVITY * delta;
	if actor._jumping && !Input.is_action_pressed("jump") && actor.velocity.y < actor.JUMP_CUTOFF:
		actor.velocity.y = lerp(actor.velocity.y, actor.JUMP_CUTOFF, 0.4);
	
	var direction = Input.get_axis("left", "right");
	
	if actor.is_on_floor():
		if !actor.jump_buffer.is_stopped():
			actor.jump();
		elif !direction:
			return idle;
		else:
			return walking;
	
	actor.velocity.x = direction * actor.SPEED;
	actor.update_position();
	
	return null;
