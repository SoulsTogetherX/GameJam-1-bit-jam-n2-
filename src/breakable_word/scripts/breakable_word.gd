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

func drop(placer: int) -> void:
	spawner.drop(placer);

func drops(placers: Array[int]) -> void:
	spawner.drops(placers);

func added_front(placer : WordPlacer, segment : Segment) -> void:
	#print("1")
	spawner.added_front(placer, segment);

func added_behind(placer : WordPlacer, segment : Segment) -> void:
	#print("2")
	spawner.added_behind(placer, segment);

func added_mid(placer : WordPlacer, segment : Segment) -> void:
	#print("3")
	spawner.added_mid(placer, segment);

func empty(placer : WordPlacer) -> void:
	#print("4")
	spawner.remove_this(placer);
