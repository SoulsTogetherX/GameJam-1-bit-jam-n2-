extends CharacterBody2D

const SPEED               : int    =  300;
const JUMP_VELOCITY       : int    = -400;
const JUMP_CUTOFF         : int    = -5;
const GRAVITY             : int    =  1960 / 2;

@onready var coyote_timer : Timer  = $coyote_timer;
@onready var jump_buffer  : Timer  = $jump_buffer;
@onready var detector     : Area2D = $interactable_detector;

@export var cam           : CameraFollow = null;

var _jumping : bool = false;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var detecteds = detector.get_overlapping_areas();
		if detecteds.size() > 0:
			detecteds[0].owner.action();
	if event.is_action_pressed("jump"):
		cam.shake(10., Vector3(10., 10., 10), Vector3(1., 0.1, 0.1));

func _physics_process(delta) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY * delta;
		if _jumping && !Input.is_action_pressed("jump") and velocity.y < JUMP_CUTOFF:
			velocity.y = lerp(velocity.y, float(JUMP_CUTOFF), 0.4);
	else:
		velocity.y = 0;
		coyote_timer.start();
		_jumping = false;
	
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer.start();
	
	if ((!coyote_timer.is_stopped() && Input.is_action_just_pressed("jump")) || (!jump_buffer.is_stopped() && is_on_floor())):
		velocity.y = JUMP_VELOCITY;
		_jumping = true;
		coyote_timer.stop();
		jump_buffer.stop();
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	cam.update_position();
