extends State

@export var walking : State;
@export var jumping : State;
@export var idle : State;

var tw : Tween;
var has_jumped : bool = false;

func state_name():
	return "falling";

func enter() -> void:
	actor.coyote_timer.start();
	if !has_jumped:
		actor.animation_player.play("falling");
	print(state_name())
	#tw = create_tween();
	#tw.tween_property(actor, "scale", Vector2(1, 1), 0.1);

func exit() -> void:
	actor.velocity.y = 0;
	has_jumped = false;
	actor.land_steps.play(0);
	#tw.kill();

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		if actor.coyote_timer.is_stopped():
			actor.jump_buffer.start();
		elif !has_jumped:
			actor.jump_buffer.stop();
			return jumping;
	
	if has_jumped && !Input.is_action_pressed("jump") && actor.velocity.y < actor.JUMP_CUTOFF:
		actor.velocity.y = lerp(actor.velocity.y, actor.JUMP_CUTOFF, 0.4);
	
	var direction = Input.get_axis("left", "right");
	if actor.is_on_floor():
		if !actor.jump_buffer.is_stopped():
			actor.jump_buffer.stop();
			return jumping;
		elif !direction:
			return idle;
		else:
			return walking;
	
	actor.velocity.y += actor.GRAVITY * delta;
	actor.velocity.x = direction * actor.SPEED;
	actor.update_position();
	
	return null;
