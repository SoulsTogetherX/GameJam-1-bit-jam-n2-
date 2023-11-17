extends State

@export var idle : State;
@export var walk : State;
@export var jumping : State;
@export var falling : State;

var tw : Tween;

func state_name():
	return "slow_down";

func enter() -> void:
	tw = create_tween();
	tw.tween_property(actor.get_node("tweener"), "scale", Vector2(1, 1), 0.1);
	tw.tween_property(actor.get_node("tweener"), "scale", Vector2(1.1, 1.), 0.2);
	actor.animation_player.play("idle");

func exit() -> void:
	tw.kill();
	pass;

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(delta: float) -> State:
	if Input.is_action_just_pressed("jump"):
		return jumping
	if !actor.is_on_floor():
		return falling;
	
	if Input.get_axis("left", "right"):
		return walk;
	
	actor.velocity.x = lerp(actor.velocity.x, 0., pow(0.3, delta));
	if abs(actor.velocity.x) <= 0.01:
		actor.velocity.x = 0;
		return idle;
	
	actor.update_position();
	return null;
