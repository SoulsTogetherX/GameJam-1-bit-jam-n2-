class_name StateMachine extends Node

@export
var starting_state: State;
var current_state: State;
var states: Array[State];

# Initialize the state machine by giving each child state a reference to the
# actor object it belongs to and enter the default starting_state.
func init(actor : Node, stateObj : StateObj, machineIdx : int) -> void:
	for child in get_children():
		child.actor = actor;
		child.stateObj = stateObj;
		child.machineIdx = machineIdx;
		states.append(child);

	# Initialize to the default state
	await actor.ready;
	change_state(starting_state);

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit();

	current_state = new_state;
	current_state.enter();

# Change to the new state forcibly
func force_change_state(new_state_name: String) -> void:
	var new_state = null;
	for state in states:
		if state.state_name() == new_state_name:
			new_state = state;
			break;
	assert(new_state != null, "ERROR: given state_name cannot be found in state array.");

	if current_state:
		current_state.exit();

	current_state = new_state;
	current_state.enter();

# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta);
	if new_state:
		change_state(new_state);

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event);
	if new_state:
		change_state(new_state);

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta);
	if new_state:
		change_state(new_state);
