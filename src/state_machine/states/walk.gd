extends State

@export var slowDown : State;
@export var jumping : State;
@export var falling : State;
@export var push : State;

@onready var time : Timer = $Timer;
@onready var push_area : Area2D = $"../../../Area2D";
var tw : Tween;

func state_name():
	return "walk";

func enter() -> void:
#	tw = create_tween();
#	tw.tween_property(actor, "scale", Vector2(1, 1), 0.1);
#	tw.tween_property(actor, "scale", Vector2(1.1, 1.), 0.2);
	time.start();
	actor.animation_player.play("walk");

func exit() -> void:
	#tw.kill();
	time.stop();

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(_delta: float) -> State:
	var direction = Input.get_axis("left", "right");
	actor.turn(direction == -1);
	if !direction:
		return slowDown;
	
	var bods = push_area.get_overlapping_bodies();
	if bods.size() > 0:
		return push;
	
	actor.velocity.x = direction * actor.SPEED;
	
	if Input.is_action_just_pressed("jump"):
		return jumping;
	if !actor.is_on_floor():
		return falling;
	
	actor.update_position();
	
	return null;

func _on_timer_timeout() -> void:
	actor.wall_steps.play(-sign(actor.velocity.x));
