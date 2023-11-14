extends Area2D

@export var check_thing : bool = false;
@export var check_no : bool = false;
@export var check_every : bool = false;

@export var connected : Array[Node];
@export var me_offset : Vector2;
@export var connected_offset : Vector2;

var _thing_entered : bool = false;
var _no_entered : bool = false;
var _every_entered : bool = false;

var _states : Array[bool];

func _ready() -> void:
	for i in connected.size():
		_states.append(connected[i].disabled);

func _draw() -> void:
	for con in connected:
		if con is Node2D:
			var me = global_position - position;
			var you = (con.global_position - global_position) * 0.5;
			
			var to_from = Vector2(me.x, you.y);
			draw_line(me, to_from, Color.WHITE, 1.5);
			draw_line(me, to_from, Color.BLACK, 1.0);
			draw_line(me, to_from, Color.WHITE, 0.5);
			
			draw_line(to_from, you, Color.WHITE, 1.5);
			draw_line(to_from, you, Color.BLACK, 1.0);
			draw_line(to_from, you, Color.WHITE, 0.5);

func _process(delta: float) -> void:
	queue_redraw();

func _on_body_entered(body: Node2D) -> void:
	if body.owner is Thing:
		_thing_entered = true;
	elif body.owner is No:
		_no_entered = true;
	elif body.owner is Every:
		_every_entered = true;
	check_to_toggle();

func _on_body_exited(body: Node2D) -> void:
	if body.owner is Thing:
		_thing_entered = false;
	elif body.owner is No:
		_no_entered = false;
	elif body.owner is Every:
		_every_entered = false;
	check_to_toggle();

func check_to_toggle() -> void:
	if check_thing && _thing_entered:
		$AudioStreamPlayer.play();
		for i in connected.size():
			connected[i].disabled = !_states[i];
			modulate.a = 0.4;
		return;
	
	if check_no && _no_entered:
		$AudioStreamPlayer.play();
		for i in connected.size():
			connected[i].disabled = !_states[i];
			modulate.a = 0.4;
		return;
	
	if check_every && _every_entered:
		$AudioStreamPlayer.play();
		for i in connected.size():
			connected[i].disabled = !_states[i];
			modulate.a = 0.4;
		return;
	
	for i in connected.size():
		connected[i].disabled = _states[i];
	modulate.a = 0.2;
