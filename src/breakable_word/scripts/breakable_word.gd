@tool
class_name Breakable extends Node2D

var _isReady : bool = false;

@onready var spawner : Spawner = $breakable_spawner;

@export_multiline var text : String = "":
	get:
		return spawner.text;
	set(val):
		if not _isReady:
			await ready;
		spawner.text = val;

func _ready():
	_isReady = true;

func drop(segment: int, placer: int) -> void:
	spawner.drop(placer, segment);

func drops(segments: Array[Array], placers: Array[int]) -> void:
	spawner.drops(placers, segments);
