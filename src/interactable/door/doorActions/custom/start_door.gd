extends DoorActions

func action(state : Door.STATE):
	match state:
		Door.STATE.LOCKED:
			_door.lockAnimation();
		Door.STATE.OPEN:
			_door.close();
		Door.STATE.CLOSED:
			_door.open();
