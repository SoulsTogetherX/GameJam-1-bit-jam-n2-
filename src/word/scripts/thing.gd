class_name Thing extends Node2D

const GRAVITY   : int  =  980;
const MAX_SPEED : int  = 20;
var attached_offset : Vector2 = Vector2.ZERO;
var attached    : bool = false;
var hold        : bool = false

@export var door_action : DoorActions;
@onready var actor = $segment_;

func _ready() -> void:
	$segment_/Area2D/CollisionShape2D.shape.extents = $segment_.get_rect().size * 0.5;

func _physics_process(delta: float) -> void:
	if attached:
		var vec = attached_offset + get_global_mouse_position() - $segment_.global_position;
		if vec.length() > MAX_SPEED:
			vec = vec.normalized() * MAX_SPEED;
		$segment_.move_and_collide(vec);
		
		$segment_.velocity = Vector2.ZERO;
	elif !hold:
		$segment_.velocity.y += GRAVITY * delta;
		$segment_.move_and_slide();

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		if attached:
			attached = false;
			return;
		
		attached = true;
		if door_action != null:
			door_action.attached.emit();
		
		$segment_.rotation = 0;
		var max_offset = $segment_.get_rect().size * 0.5 - Vector2(1, 1);
		attached_offset = ($segment_.global_position - $segment_.get_global_mouse_position()).clamp(-max_offset, max_offset);
