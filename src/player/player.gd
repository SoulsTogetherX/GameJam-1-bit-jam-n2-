class_name Player extends CharacterBody2D

const SPEED               : int    =  300;
const JUMP_VELOCITY       : int    = -400;
const JUMP_CUTOFF         : float  = -5.;
const GRAVITY             : int    =  1960 / 2;

@onready var coyote_timer : Timer    = $coyote_timer;
@onready var jump_buffer  : Timer    = $jump_buffer;
@onready var detector     : Area2D   = $interactable_detector;
@onready var state_contr  : StateObj = $StateObj;

@export var _cam           : CameraFollow = null;
var _tween                 : Tween;
var _jumping               : bool = false;
var _selecting             : Array[Segment];
var _held                  : Segment;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && _selecting.is_empty():
		var detecteds = detector.get_overlapping_areas();
		for detected in detecteds:
			var subject = detected.owner;
			if subject is Segment:
				if is_on_floor() && !subject.freeze:
					_selecting.append(subject);
			else:
				subject.action();
		if !_selecting.is_empty():
			if _held:
				_selecting.append(_held);
			state_contr.force_change_state("selecting", 0);

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
