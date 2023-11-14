extends Area2D

@export var check_thing : bool = false;
@export var check_no : bool = false;
@export var check_every : bool = false;
@export var check_nothing : bool = false;
@export var check_yesthing : bool = false;
@export var other_way : bool = false;

@export var connected : Array[Node];
@export var me_offset : Vector2;
@export var connected_offset : Vector2;

var _thing_entered : bool = false;
var _no_entered : bool = false;
var _every_entered : bool = false;
var _nothing_entered : bool = false;
var _yesthing_entered : bool = false;

var _thing = null;
var _no = null;

var _states : Array[bool];

func _ready() -> void:
	for i in connected.size():
		_states.append(connected[i].disabled);
	$Sprite2D.modulate.a = 0.5;

func _draw() -> void:
	for con in connected:
		if con is Node2D:
			var you = to_local(con.global_position);
			
			if other_way:
				var to_from = Vector2(you.x, 0);
				draw_line(Vector2.ZERO, to_from, Color.WHITE, 1.5);
				draw_line(Vector2.ZERO, to_from, Color.BLACK, 1.0);
				draw_line(Vector2.ZERO, to_from, Color.WHITE, 0.5);
				
				draw_line(to_from, you, Color.WHITE, 1.5);
				draw_line(to_from, you, Color.BLACK, 1.0);
				draw_line(to_from, you, Color.WHITE, 0.5);
			else:
				var to_from = Vector2(0, you.y);
				draw_line(Vector2.ZERO, to_from, Color.WHITE, 1.5);
				draw_line(Vector2.ZERO, to_from, Color.BLACK, 1.0);
				draw_line(Vector2.ZERO, to_from, Color.WHITE, 0.5);
				
				draw_line(to_from, you, Color.WHITE, 1.5);
				draw_line(to_from, you, Color.BLACK, 1.0);
				draw_line(to_from, you, Color.WHITE, 0.5);

func _process(delta: float) -> void:
	queue_redraw();

func _on_body_entered(body: Node2D) -> void:
	if body.owner is Thing:
		_thing = body.owner;
		_thing_entered = true;
	elif body.owner is No:
		_no_entered = true;
		_no = body.owner;
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
	if _no_entered:
		if _no.actor._text == "Nothing":
			_nothing_entered = true;
			_no_entered = false;
		else:
			_nothing_entered = false;
		if _no.actor._text == "Yesthing?":
			_yesthing_entered = true;
			_no_entered = false;
		else:
			_yesthing_entered = false;
	elif _nothing_entered:
		if _no.actor._text != "Nothing":
			_nothing_entered = false;
			if _no.actor._text == "Yesthing?":
				_yesthing_entered = true;
			else:
				_no_entered = true;
	elif _nothing_entered:
		if _no.actor._text != "Yesthing":
			_yesthing_entered = false;
			if _no.actor._text == "Nothing?":
				_nothing_entered = true;
			else:
				_no_entered = true;
	
	if check_thing && _thing_entered && _thing.visible:
		$AudioStreamPlayer.play();
		for i in connected.size():
			connected[i].disabled = !_states[i];
			$Sprite2D.modulate.a = 0.7;
		return;
	
	if check_no && _no_entered:
		$AudioStreamPlayer.play();
		for i in connected.size():
			connected[i].disabled = !_states[i];
			$Sprite2D.modulate.a = 0.7;
		return;
	
	if check_every && _every_entered:
		$AudioStreamPlayer.play();
		for i in connected.size():
			connected[i].disabled = !_states[i];
			$Sprite2D.modulate.a = 0.7;
		return;
	
	if check_nothing && _nothing_entered:
		$AudioStreamPlayer.play();
		for i in connected.size():
			connected[i].disabled = !_states[i];
			$Sprite2D.modulate.a = 0.7;
		return;
	
	if check_yesthing && _yesthing_entered:
		$AudioStreamPlayer.play();
		for i in connected.size():
			connected[i].disabled = !_states[i];
			$Sprite2D.modulate.a = 0.7;
		return;
	
	for i in connected.size():
		connected[i].disabled = _states[i];
	$Sprite2D.modulate.a = 0.5;
