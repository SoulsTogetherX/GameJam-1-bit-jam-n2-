@tool
extends PathFollow2D

var tween : Tween;

signal toggle();

@export_range(0.0, 1.0) var starting_ratio = 0.0:
	set(val):
		starting_ratio = val;
		progress_ratio = val;
		global_rotation = 0;

@export var speed: float  = 4.;
@export var disabled: bool  = false;

func _ready() -> void:
	if Engine.is_editor_hint():
		return;

	tween = create_tween().set_loops();
	tween.tween_method(loop_, 0.0, 1.0, 4.5);
	tween.tween_callback(func(): progress_ratio = 0.0);

func loop_(val : float):
	progress_ratio = fmod(val + starting_ratio, 1.);
	global_rotation = 0;


func _on_toggle() -> void:
	disabled = true;
