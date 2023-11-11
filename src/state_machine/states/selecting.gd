extends State

@export var idle : State;

const HOLD_OFFSET : Vector2 = Vector2(0, -30);

var select_idx  : int;
var max_selects : int;

func state_name():
	return "selecting";

func enter() -> void:
	for held in actor._selecting:
		held.hold();
		GlobalStuff.swap_parent(held, owner);
	max_selects = actor._selecting.size() - 1;
	select_idx  = max_selects;
	await organize_start();

func exit() -> void:
	for held in actor._selecting:
		held.drop();
	actor._selecting.clear();

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		return idle;
	var dir : int = int(event.is_action_pressed("right")) - int(event.is_action_pressed("left"));
	_change_index(dir);
	await organize_selections(dir);
	
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(_delta: float) -> State:
	actor._cam.update_position();
	return null;

func organize_start():
	var tw : Tween = create_tween();
	match max_selects:
		0:
			tw.tween_property(actor._selecting[0], "position", HOLD_OFFSET, 0.2);
		1:
			pass;
		_:
			pass;
	await tw.finished;

func _change_index(dir : int):
	select_idx += dir;
	if select_idx < 0:
		select_idx = max_selects;
	elif select_idx > max_selects:
		select_idx = 0;

func organize_selections(dir : int):
	match max_selects:
		0:
			
			pass;
		1:
			pass;
		_:
			pass;
