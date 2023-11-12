extends DoorActions

func _ready() -> void:
	super();
	print(_no);
	_no.pause = true;
	print(_no.pause);

func on_locked():
	_door.lockAnimation();
	_no.pause = false;
	_no.hold = false;

func _on_objective() -> void:
	_door.close();

func _on_objective_undo() -> void:
	_door.lock();

func on_closed():
	_door.open()
