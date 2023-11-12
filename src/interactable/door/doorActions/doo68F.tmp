class_name DoorActions extends Node

@onready var _door     : Door = get_parent();
@export_file("*.tscn") var _nextRoom;

func action(state : Door.STATE):
	match state:
		Door.STATE.LOCKED:
			on_locked();
		Door.STATE.OPEN:
			on_open();
		Door.STATE.CLOSED:
			on_closed();

func on_locked():
	pass;

func on_open():
	pass;

func on_closed():
	pass;
