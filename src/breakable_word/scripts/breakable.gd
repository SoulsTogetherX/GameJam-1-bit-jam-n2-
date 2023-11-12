@tool
class_name Breakable extends Node2D

@export_multiline var text : String = "aaaaaa":
	get:
		return spawner.text;
	set(val):
		text = val;
		if !isReady:
			await ready;
		update_spawner(spacing, val);

@export var spacing : float = 2.:
	set(val):
		spacing = val;
		if !isReady:
			await ready;
		update_spawner(val, text);

var spawner : Spawner;
var isReady : bool = false
func _ready() -> void:
	spawner = $spawner;
	isReady = true;

func update_spawner(spacing : float, txt : String) -> void:
	spawner.spacing = spacing;
	spawner.text = txt;
