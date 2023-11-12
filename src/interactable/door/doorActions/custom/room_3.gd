extends DoorActions

func _ready() -> void:
	super();

func on_locked():
	_door.lockAnimation();
	_every.pause = false;
	_every.hold = false;

func _on_objective() -> void:
	_door.close();

func _on_objective_undo() -> void:
	_door.lock();

func on_closed():
	_door.open()
