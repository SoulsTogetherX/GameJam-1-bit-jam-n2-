class_name StateObj extends Node

@export var actor : Node2D;
@export var state_machines : Array[StateMachine];

func _ready() -> void:
	for idx in state_machines.size():
		var machine = state_machines[idx];
		machine.init(actor, self, idx);

func force_change_state(new_state_name: String, idx: int) -> void:
	state_machines[idx].force_change_state(new_state_name);

func _unhandled_input(event: InputEvent) -> void:
	for machine in state_machines:
		if machine:
			machine.process_input(event);

func _physics_process(delta: float) -> void:
	for machine in state_machines:
		if machine:
			machine.process_physics(delta);

func _process(delta: float) -> void:
	for machine in state_machines:
		if machine:
			machine.process_frame(delta);

func compairStateNames(stateNames: Array[String], idx: int) -> bool:
	var thisStateName = state_machines[idx].current_state.state_name();
	for stateName in stateNames:
		if thisStateName == stateName:
			return true;
	return false;

func compairStateName(stateName: String, idx: int) -> bool:
	return state_machines[idx].current_state.state_name() == stateName;
