class_name DoorActions extends Node

@onready var _door     : Door = get_parent();
@export_file("*.tscn") var _nextRoom;

func action(state : Door.STATE):
	pass;
