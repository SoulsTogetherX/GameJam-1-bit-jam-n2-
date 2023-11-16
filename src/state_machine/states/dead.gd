extends State

var spd_x;
@onready var time : Timer = $Timer;
@onready var sound : AudioStreamPlayer = $AudioStreamPlayer;

func state_name():
	return "dead";

func enter() -> void:
	if time.is_stopped():
		spd_x = -sign(actor.velocity.x) * 70;
		actor.modulate.a = 0.7;
		actor.velocity.y -= 400;
		sound.play();
		time.start();
	actor.animation_player.play("falling");
	
func exit() -> void:
	pass;

func process_input(_event: InputEvent) -> State:
	return null;

func process_frame(_delta: float) -> State:
	actor.modulate.a = 0.7 + float(actor.modulate.a == 0.7) * 0.3;
	return null;

func process_physics(delta: float) -> State:
	actor.velocity.y += actor.GRAVITY * delta;
	
	actor.velocity.x = spd_x;
	actor.update_position();
	
	return null;

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene();
