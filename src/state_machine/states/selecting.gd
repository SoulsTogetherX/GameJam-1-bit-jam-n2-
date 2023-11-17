extends State

@export var idle : State;

const HOLD_OFFSET : Vector2 = Vector2(0, -20);
const WORD_SPACING : int = 5;

var select_idx  : int;
var max_selects : int;
var _arrow      : Sprite2D;
var _onHold     : bool = false;

func state_ready():
	_arrow = Sprite2D.new();
	await actor.ready;
	actor.add_child(_arrow);
	
	_arrow.texture = load("res://assets/sprites/player/arrow.png");
	_arrow.scale = Vector2(0.5, 0.5);
	_arrow.modulate.a = 0.;

func state_name():
	return "selecting";

func enter() -> void:
	_arrow.position = Vector2(0, -10);
	for held in actor._selecting:
		held.hold();
		GlobalStuff.swap_parent(held, owner);
	max_selects = actor._selecting.size() - 1;
	select_idx  = max_selects;
	organize_start();

func exit() -> void:
	for held in actor._selecting:
		held.drop();
	await organize_end();
	actor._selecting.clear();

func process_input(event: InputEvent) -> State:
	if _onHold:
		return null;
	
	if event.is_action_pressed("jump"):
		return idle;
	var dir : int = int(event.is_action_pressed("right")) - int(event.is_action_pressed("left"));
	select_idx = _loop_index(select_idx, dir);
	organize_selections(dir);
	
	return null;

func process_frame(_delta: float) -> State:
	return null;

func process_physics(_delta: float) -> State:
	actor._cam.update_position();
	return null;

func organize_start():
	_onHold = true;
	var tw : Tween = create_tween().set_parallel();
	match max_selects:
		0:
			var obj : Segment = actor._selecting[0];
			tw.tween_property(obj, "position", HOLD_OFFSET,       0.2);
		1:
			var obj1 : Segment = actor._selecting[0];
			var obj2 : Segment = actor._selecting[1];
			GlobalStuff.swap_parent_simple(_arrow, obj2);
			
			var width2Mid = obj2.get_width() * 0.5;
			var total_width = (WORD_SPACING + (obj1.get_width() + obj2.get_width()) * 0.5) * 0.5;
			
			var offset_1 = HOLD_OFFSET;
			offset_1.x = -total_width - width2Mid;
			tw.tween_property(obj1, "position", offset_1,          0.2);
			tw.tween_property(obj1, "scale",    Vector2(0.8, 0.8), 0.2);
			
			var offset_2 = HOLD_OFFSET;
			offset_2.x = total_width - width2Mid;
			tw.tween_property(obj2, "position", offset_2,          0.2);
			
			_arrow.modulate.a = 1.;
		_:
			pass;
	
	await tw.finished;
	tw.kill();
	_onHold = false;

func organize_end():
	GlobalStuff.swap_parent(_arrow, self);
	
	var tw : Tween = create_tween().set_parallel();
	for selected in actor._selecting:
		tw.tween_property(selected, "scale", Vector2(1., 1.), 0.1);
	tw.tween_property(_arrow, "modulate:a", 0., 0.1);
	
	await tw.finished;
	tw.kill();

func _loop_index(idx : int, dir : int) -> int:
	return (((idx + dir) % max_selects) + max_selects) % max_selects;

func organize_selections(dir : int):
	var old   = _loop_index(select_idx, -dir);
	var next  = _loop_index(select_idx, dir);
	var hide  = _loop_index(old, -dir);
	
	var tw : Tween = create_tween().set_parallel();
	if max_selects != 0:
		GlobalStuff.swap_parent_simple(_arrow, actor._selecting[select_idx]);
		match dir:
			-1:
				_swap_left(tw, old, next, hide);
			1:
				_swap_right(tw, old, next, hide);
	else:
		GlobalStuff.waggle(actor._selecting[0], 0.2, 5 * dir);
	
	await tw.finished;
	tw.kill();

func _width_above(idx : int) -> float:
	return actor._selecting[_loop_index(idx, 1)].get_width();

func _width_below(idx : int) -> float:
	return actor._selecting[_loop_index(idx, -1)].get_width();

func _swap_left(tw : Tween, old : int, next: int, hide : int):
	var next_      : Segment = actor._selecting[next];
	var selected_  : Segment = actor._selecting[select_idx];
	var past_      : Segment = actor._selecting[old];
	var hide_      : Segment = actor._selecting[hide];
	
	var width_left  := _width_below(select_idx);
	var width_min   := selected_.get_width();
	var width_right := _width_above(select_idx);
	
	if old > select_idx:
		pass;
	else:
		var selected_w = selected_.get_width() * 0.5;
		var total_width = (WORD_SPACING + WORD_SPACING + (next_.get_width() + selected_.get_width() + past_.get_width()) * 0.5) * 0.5;
		
		
		
		var offset_1 = HOLD_OFFSET;
		offset_1.x = -total_width - selected_w;
		tw.tween_property(selected_, "position", offset_1,        0.1);
		tw.tween_property(selected_, "scale"   , Vector2(1., 1.), 0.1);
			
		var offset_2 = HOLD_OFFSET;
		offset_2.x = total_width - selected_w;
		tw.tween_property(next_,     "position", offset_2,          0.1);
		tw.tween_property(next_,     "scale",    Vector2(0.8, 0.8), 0.1);
		
		
		#tw.tween_property(hide_)
		#tw.tween_property(next_)
		

func _swap_right(tw : Tween, old : int, next: int, hide : int):
	var old_      : Segment = actor._selecting[old];
	var selected_ : Segment = actor._selecting[select_idx];
	var next_     : Segment = actor._selecting[next];
	
	if old > select_idx:
		
		pass;
	else:
		pass;
