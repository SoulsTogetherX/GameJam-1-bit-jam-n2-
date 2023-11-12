@tool
class_name Breakable extends Node2D

@export_multiline var text : String = "aaaaaa":
	get:
		return spawner.text;
	set(val):
		text = val;
		if !isReady:
			await ready;
		update_spawner(val);

@export var spacing : float = 2.;

var spawner : Spawner;
var isReady : bool = false
func _ready() -> void:
	spawner = $spawner;
	spawner.spacing = spacing;
	isReady = true;

func update_spawner(txt : String) -> void:
	spawner.text = txt;
