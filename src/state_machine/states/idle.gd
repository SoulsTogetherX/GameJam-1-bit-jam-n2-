extends State

@export var walk : State;
@export var jumping : State;
@export var falling : State;

var tw : Tween;

func state_name():
	return "idle";

func enter() -> void:
	tw = create_tween();
	tw.tween_property(actor.get_node("tweener"), "scale", Vector2(1, 1), 0.2);
	tw.chain().set_loops();
	tw.tween_property(actor.get_node("tweener"), "scale", Vector2(1, 1.01), 0.5);
	tw.tween_property(actor.get_node("tweener"), "scale", Vector2(1, 0.99), 0.5);
	actor.animation_player.play("idle");

func exit() -> void:
	tw.kill();

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(_delta: float) -> State:
	actor.update_position();
	if Input.is_action_just_pressed("jump"):
		return jumping;
	if !actor.is_on_floor():
		return falling;
	
	if Input.get_axis("left", "right"):
		return walk;
	
	return null;
