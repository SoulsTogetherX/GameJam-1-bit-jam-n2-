class_name Player extends CharacterBody2D

const SPEED               : int    =  300;
const JUMP_VELOCITY       : int    = -400;
const JUMP_CUTOFF         : float  = -5.;
const GRAVITY             : int    =  980;

@onready var coyote_timer : Timer    = $coyote_timer;
@onready var jump_buffer  : Timer    = $jump_buffer;
@onready var detector     : Area2D   = $interactable_detector;
@onready var state_contr  : StateObj = $StateObj;
@onready var wall_steps   : CPUParticles2D = $walk_particles;

@export var _cam           : CameraFollow = null;
var _tween                 : Tween;
var _jumping               : bool = false;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var detecteds = detector.get_overlapping_areas();
		for detected in detecteds:
			if !(detected.owner is Door) || is_on_floor():
				detected.owner.action();

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
