extends DoorActions

func on_locked():
	_door.lockAnimation();
	_thing.pause = false;
	_thing.hold = false;

func _on_objective() -> void:
	_door.close();

func _on_objective_undo() -> void:
	_door.lock();

func on_closed():
	_door.open()
