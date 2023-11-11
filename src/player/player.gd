extends CharacterBody2D

const SPEED               : int    =  300;
const JUMP_VELOCITY       : int    = -400;
const JUMP_CUTOFF         : float  = -5.;
const GRAVITY             : int    =  1960 / 2;

@onready var coyote_timer : Timer  = $coyote_timer;
@onready var jump_buffer  : Timer  = $jump_buffer;
@onready var detector     : Area2D = $interactable_detector;

@export var _cam           : CameraFollow = null;
var _tween                 : Tween;
var _jumping               : bool = false;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var detecteds = detector.get_overlapping_areas();
		if detecteds.size() > 0:
			detecteds[0].owner.action();

func _physics_process(delta) -> void:	
	pass;

func update_position() -> void:
	move_and_slide();
	_cam.update_position();

func jump() -> void:
	velocity.y = JUMP_VELOCITY;
	_jumping = true;
	
	coyote_timer.stop();
	jump_buffer.stop();
