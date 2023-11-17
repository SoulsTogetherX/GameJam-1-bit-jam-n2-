extends CharacterBody2D


const SPEED         : float = 300.0
const JUMP_VELOCITY : float = -400.0
const GRAVITY       : float =  2851.8;

var on_floor : bool = false;

func _physics_process(delta: float) -> void:
	if is_on_floor():
		if !on_floor:
			velocity.y += 0;
			$AnimationPlayer.play("idle");
			$land_emiter.play();
			on_floor = true;
			$"../New_Options".modulate.a = 1.0;
			return;
	else:
		on_floor = false;
		if position.y > 250:
			$"../New_Options".visible = false
	
	velocity.y += GRAVITY * delta;
	move_and_slide();
