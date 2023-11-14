extends StaticBody2D

@export var disabled: bool = false:
	set(val):
		disabled = val;
		if disabled:
			collision_layer = 0;
			modulate.a = 0.7;
		else:
			collision_layer = 129;
			modulate.a = 1.;
