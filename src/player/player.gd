class_name Player extends CharacterBody2D

const SPEED               : int    =  300;
const JUMP_VELOCITY       : int    = -400;
const JUMP_CUTOFF         : float  = -5.;
const GRAVITY             : int    =  980;

@onready var coyote_timer : Timer    = $coyote_timer;
@onready var jump_buffer  : Timer    = $jump_buffer;
@onready var detector     : Area2D   = $interactable_detector;
@onready var state_contr  : StateObj = $StateObj;

@onready var wall_steps   : Node2D   = $footstep_emiter;
@onready var land_steps   : Node2D   = $land_emiter;
@onready var jump_steps   : Node2D   = $jump_emiter;

@export var _cam           : CameraFollow = null;
var _jumping               : bool = false;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && is_on_floor():
		var detecteds = detector.get_overlapping_areas();
		for detected in detecteds:
			detected.owner.action();

func _physics_process(_delta) -> void:	
	pass;

func update_position() -> void:
	move_and_slide();
	_cam.update_position();

func jump() -> void:
	jump_steps.play(0);
	velocity.y = JUMP_VELOCITY;
	_jumping = true;
	
	coyote_timer.stop();
	jump_buffer.stop();
