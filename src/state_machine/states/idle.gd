extends State

@export var walk : State;
@export var jumping : State;
@export var falling : State;

var tw : Tween;

func state_name():
	return "idle";

func enter() -> void:
	print(state_name())
#	tw = create_tween();
#	tw.tween_property(actor, "scale", Vector2(1, 1), 0.1);
#	tw.chain().set_loops();
#	tw.tween_property(actor, "scale", Vector2(1, 1.05), 0.5);
#	tw.tween_property(actor, "scale", Vector2(1, 0.95), 0.5);
	actor.animation_player.play("idle");

func exit() -> void:
	#tw.kill();
	pass;

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(_delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		return jumping;
	if !actor.is_on_floor():
		return falling;
	
	if Input.get_axis("left", "right"):
		return walk;
	
	actor.update_position();
	return null;
