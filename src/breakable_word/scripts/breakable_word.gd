@tool
class_name Breakable extends Node2D

var isReady : bool = false;
var placers : Array[WordPlacer] = [];

@onready var spawner : Spawner = $breakable_spawner;

@export_multiline var text : String = "":
	get:
		return spawner.text;
	set(val):
		if not isReady:
			await ready;
		spawner.text = val;

func _ready():
	isReady = true;
