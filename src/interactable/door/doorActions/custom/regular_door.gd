extends DoorActions

func action(state : Door.STATE):
	match state:
		Door.STATE.LOCKED:
			_door.lockAnimation();
		Door.STATE.OPEN:
			get_tree().change_scene_to_file(_nextRoom);
		Door.STATE.CLOSED:
			_door.open();
