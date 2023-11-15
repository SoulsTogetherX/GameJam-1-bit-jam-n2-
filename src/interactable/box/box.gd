extends RigidBody2D

@onready var area_2d: Area2D = $Area2D

func _process(delta: float) -> void:
	for c in area_2d.get_overlapping_bodies():
		print((position - c.position).normalized() * 5)
		apply_central_impulse(sign(position.y - c.position.y) * 5);
