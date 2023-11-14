class_name Dragable extends Node2D

const GRAVITY   : int  =  980;
const MAX_SPEED : int  = 20;
var attached_offset : Vector2 = Vector2.ZERO;
var attached    : bool = false;
@export var hold        : bool = true
@export var pause       : bool = true;

@onready var cannotPlace = load("res://assets/sound/word/can't_place.wav");
@onready var land = load("res://assets/sound/word/land.wav");
@onready var place = [
	load("res://assets/sound/word/place_1.wav"),
	load("res://assets/sound/word/place_2.wav"),
	load("res://assets/sound/word/place_3.wav"),
	load("res://assets/sound/word/place_4.wav")
];
@onready var audioPlayer : AudioStreamPlayer = $AudioStreamPlayer;

@onready var actor = $segment_;
static var click_particle = preload("res://assets/particles/click_text_particle.tscn");

func _ready() -> void:
	actor.get_node("Area2D/CollisionShape2D").shape.extents = actor.get_rect().size * 0.5;
	actor.collision_layer = 10;
	actor.collision_mask = 1;

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if pause:
		if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
			var particle = click_particle.instantiate();
			add_child(particle);
			particle.global_position = get_global_mouse_position();
			GlobalStuff.waggle(actor, 0.3, 5 * sign(get_local_mouse_position().x));
			
			audioPlayer.volume_db = -20;
			audioPlayer.stream = place[randi() % place.size()];
			audioPlayer.play();
		return;
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		audioPlayer.volume_db = -20;
		if attached:
			var a = actor.get_node("Area2D");
			prints(a.collision_mask, a.collision_layer);
			if a.get_overlapping_areas().size() > 1 or a.get_overlapping_bodies().size() > 1:
				audioPlayer.stream = cannotPlace;
				audioPlayer.play();
				return;
			
			audioPlayer.stream = place[randi() % place.size()];
			audioPlayer.play();
			
			attached = false;
			hold     = true;
			actor.global_rotation = 0;
			actor.modulate.a = 1.;
			if self is Every:
				actor.collision_layer = 42;
			else:
				actor.collision_layer = 10;
			actor.collision_mask = 1;
			actor.get_node("CollisionShape2D").collision_layer = 7;
			return;
		
		audioPlayer.stream = place[randi() % place.size()];
		audioPlayer.play();
		attached = true;
		
		actor.global_rotation_degrees = -5;
		actor.modulate.a = 0.9;
		var max_offset = actor.get_rect().size * 0.5 - Vector2(1, 1);
		attached_offset = (actor.global_position - actor.get_global_mouse_position()).clamp(-max_offset, max_offset);
		actor.get_node("CollisionShape2D").collision_layer = 0;
		if self is Every:
			actor.collision_mask = 32;
			actor.collision_layer = 40;
		else:
			actor.collision_layer = 8;

func _physics_process(delta: float) -> void:
	if pause:
		return;
	
	if attached:
		var vec = attached_offset + get_global_mouse_position() - actor.global_position;
		if vec.length() > MAX_SPEED:
			vec = vec.normalized() * MAX_SPEED;
		actor.move_and_collide(vec);
		
		actor.velocity = Vector2.ZERO;
		if self is Every:
			actor.collision_layer = 32;
			actor.collision_mask = 32;
	else:
		actor.collision_layer = 10;
		actor.collision_mask = 1;
	if !hold:
		actor.velocity.y += GRAVITY * delta;
		actor.move_and_slide();
		
		if actor.get_slide_collision_count() > 0:
			hold = true;
			audioPlayer.stream = land;
			audioPlayer.play();
