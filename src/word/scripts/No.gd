class_name No extends Node2D

@export var door : DoorActions;

func _ready() -> void:
	$Area2D/CollisionShape2D.shape.extents = $segment_.get_rect().size * 0.5;

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		for c in $Area2D.get_overlapping_bodies():
			if c.owner is Thing:
				$segment_.text = "Nothing";
				c.owner.queue_free();
				door.objective.emit();
				return;
