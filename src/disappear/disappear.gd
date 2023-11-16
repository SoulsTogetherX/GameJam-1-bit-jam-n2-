extends Node2D

@export var disabled: bool = false;

func _process(delta: float) -> void:
	if disabled:
		modulate.a = 0.;
	else:
		modulate.a = 1.;
