extends DoorActions

@export var everything : Breakable;
@export var no         : Breakable;
var onTime : bool = false;

func on_locked():
	_door.lockAnimation();
	if onTime:
		return;
	onTime = true;
	
	everything.drop(0, 1);
	print(no)
