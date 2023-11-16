extends State

@export var falling : State;

var tw : Tween;

var state 

func state_name():
	return "jumping";

func enter() -> void:
	#tw = create_tween();
	#tw.tween_property(actor, "scale", Vector2(1, 1.2), 0.1);
	actor.animation_player.play("jumping");
	falling.has_jumped = true;
	actor.jump();

func exit() -> void:
	#tw.kill();
	pass;

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(delta: float) -> State:
	if actor.is_on_floor():
		return falling;
	
	var direction = Input.get_axis("left", "right");
	actor.velocity.y += actor.GRAVITY * delta;
	actor.velocity.x = direction * actor.SPEED;
	actor.update_position();
	
	return null;
