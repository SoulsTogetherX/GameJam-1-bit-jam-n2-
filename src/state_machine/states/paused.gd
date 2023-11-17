extends State

var tw : Tween;

func state_name():
	return "paused";

func enter() -> void:
	print(state_name())
	tw = create_tween();
	tw.tween_property(actor, "scale", Vector2(1, 1), 0.1);
	tw.chain().set_loops();
	tw.tween_property(actor, "scale", Vector2(1, 1.01), 0.5);
	tw.tween_property(actor, "scale", Vector2(1, 0.99), 0.5);
	actor.animation_player.play("idle");

func exit() -> void:
	tw.kill();

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(delta: float) -> State:
	if actor.is_on_floor():
		actor.velocity.y = 0;
	else:
		actor.velocity.y += actor.GRAVITY * delta;
		actor.update_position();
	
	return null;
