extends RigidBody2D

@onready var area_2d: Area2D = $Area2D

func _process(delta: float) -> void:
	if area_2d.get_overlapping_bodies().size() == 0:
		apply_central_impulse(Vector2(0, 10));
