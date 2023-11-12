class_name Dragable extends Node2D

const GRAVITY   : int  =  980;
const MAX_SPEED : int  = 20;
var attached_offset : Vector2 = Vector2.ZERO;
var attached    : bool = false;
@onready var hold        : bool = true
@onready var pause       : bool = false;

@onready var actor = $segment_;

func _ready() -> void:
	actor.get_node("Area2D/CollisionShape2D").shape.extents = actor.get_rect().size * 0.5;
	actor.collision_layer = 9;
	actor.collision_mask = 1;
	actor.get_node("Area2D").collision_layer = 11;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if pause:
		return;
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		if attached:
			var a = actor.get_node("Area2D")
			if a.get_overlapping_areas().size() > 1 or a.get_overlapping_bodies().size() > 1:
				return;
			
			attached = false;
			hold     = true;
			actor.global_rotation = 0;
			actor.modulate.a = 1.;
			actor.collision_mask = 1;
			actor.get_node("CollisionShape2D").collision_layer = 7;
			return;
		
		attached = true;
		
		actor.global_rotation_degrees = 0;
		actor.modulate.a = 0.9;
		var max_offset = actor.get_rect().size * 0.5 - Vector2(1, 1);
		attached_offset = (actor.global_position - actor.get_global_mouse_position()).clamp(-max_offset, max_offset);
		actor.get_node("CollisionShape2D").collision_layer = 0;
		actor.collision_mask = 0;

func _physics_process(delta: float) -> void:
	if pause:
		return;
	
	if attached:
		var vec = attached_offset + get_global_mouse_position() - actor.global_position;
		if vec.length() > MAX_SPEED:
			vec = vec.normalized() * MAX_SPEED;
		actor.move_and_collide(vec);
		
		actor.velocity = Vector2.ZERO;
		actor.collision_mask = 0;
	else:
		actor.collision_mask = 1;
	if !hold:
		actor.velocity.y += GRAVITY * delta;
		actor.move_and_slide();
