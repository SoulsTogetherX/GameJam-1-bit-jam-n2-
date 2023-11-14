extends DoorActions

@export var change_thing : bool = false;
@export var change_no : bool = false;
@export var change_every : bool = false;

func on_locked():
	_door.lockAnimation();
	if change_thing:
		_thing.pause = false;
		_thing.hold = false;
		_thing.modulate.a = 1.;
	if change_no:
		_no.pause = false;
		_no.hold = false;
		_no.modulate.a = 1.;
	if change_every:
		_every.pause = false;
		_every.hold = false;
		_every.modulate.a = 1.;

func _on_objective() -> void:
	_door.close();

func _on_objective_undo() -> void:
	_door.lock();

func on_closed():
	_door.open()
