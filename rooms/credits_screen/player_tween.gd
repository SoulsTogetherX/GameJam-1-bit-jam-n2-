extends Node2D

var tween : Tween = null;

func _ready() -> void:
	tween = create_tween().set_loops();
	tween.tween_property(self, "scale", Vector2(0.3, 0.303), 0.5);
	tween.tween_property(self, "scale", Vector2(0.3, 0.297), 0.5);

func _exit_tree() -> void:
	tween.kill();
