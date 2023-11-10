extends CharacterBody2D

const SPEED               : int   =  300.0
const JUMP_VELOCITY       : int   = -400.0
const GRAVITY             : int   =  980;

@onready var coyote_timer : Timer = Timer.new()
@onready var jump_buffer  : Timer = Timer.new()



func _ready() -> void:
	add_child(coyote_timer)
	coyote_timer.wait_time = 0.3;
	coyote_timer.one_shot = true;
	coyote_timer.stop();

	add_child(jump_buffer)
	jump_buffer.wait_time = 0.1;
	jump_buffer.one_shot = true;
	jump_buffer.stop();

func _physics_process(delta) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY * delta;
	else:
		velocity.y = 0;
		coyote_timer.start();
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer.start();
	
	if ((!coyote_timer.is_stopped() && Input.is_action_just_pressed("jump")) || (!jump_buffer.is_stopped() && is_on_floor())):
		velocity.y = JUMP_VELOCITY;
		coyote_timer.stop();
		jump_buffer.stop();
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
