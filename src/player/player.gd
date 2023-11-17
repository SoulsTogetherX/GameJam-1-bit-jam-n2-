class_name Player extends CharacterBody2D

const SPEED               : int    =  2500;
const JUMP_VELOCITY       : int    = -4000;
const JUMP_CUTOFF         : float  = -50.;
const GRAVITY             : int    =  9800;
const PUSH_FORCE          : int    =  220;

@onready var coyote_timer : Timer    = $coyote_timer;
@onready var jump_buffer  : Timer    = $jump_buffer;
@onready var detector     : Area2D   = $interactable_detector;
@onready var state_contr  : StateObj = $StateObj;

@onready var wall_steps   : Node2D   = $footstep_emiter;
@onready var land_steps   : Node2D   = $land_emiter;
@onready var jump_steps   : Node2D   = $jump_emiter;

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var _cam           : CameraFollow = null;

func _ready() -> void:
	if GlobalStuff.dapper:
		$tweener/hat.visible = true;

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

static var jump_particles :PackedScene = preload("res://assets/particles/jump_particles.tscn");
func jump() -> void:
	var jp = jump_particles.instantiate();
	add_sibling(jp);
	jp.position = position;
	
	jump_steps.play(0);
	velocity.y = JUMP_VELOCITY;
	update_position();
	
	coyote_timer.stop();
	jump_buffer.stop();

func kill() -> void:
	state_contr.force_change_state("dead");

func play_footset():
	if $tweener/main.flip_h:
		wall_steps.play(1);
	else:
		wall_steps.play(-1);

func end_room_hide() -> void:
	$tweener/fade.modulate.a = 0.0;
	$tweener/main.modulate.a = 0.0;
	$tweener/hat.modulate.a = 0.0;
	process_mode = Node.PROCESS_MODE_DISABLED;

func turn(flip : bool):
	$tweener/fade.flip_h = flip;
	$tweener/main.flip_h = flip;
	$tweener/hat.flip_h = flip;
	
