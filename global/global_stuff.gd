@tool
extends Node

static var segment_font      : Font = ThemeDB.fallback_font;
static var segment_font_size : int = 16;

var bonuses_collected = [];
var total_bonuses = 10;
var start_time : int = 0;
var end_time : int = 0;

func collected_bonuses() -> int:
	return bonuses_collected.count(true);

func _ready() -> void:
	for bd in total_bonuses:
		bonuses_collected.append(false);

static func swap_parent(node : Node, parent : Node) -> void:
	var pos : Vector2;
	if node is Node2D:
		pos = node.global_position;
	if node.get_parent():
		node.get_parent().remove_child(node);
	parent.add_child(node);
	if node is Node2D:
		node.global_position = pos;

static func swap_parent_simple(node : Node, parent : Node) -> void:
	if node.get_parent():
		node.get_parent().remove_child(node);
	parent.add_child(node);

static func waggle(obj : Node2D, length : float = 1.5, max_ : float = 5):
	var tw = obj.create_tween();
	var div = length / 3;
	tw.tween_property(obj, "rotation_degrees",  max_, div);
	tw.tween_property(obj, "rotation_degrees", -max_, div);
	tw.tween_property(obj, "rotation_degrees",  0,   div);
	tw.play();
	
	await tw.finished;
	tw.kill();

static func wait(obj : Node, delay : float):
	var tw = obj.create_tween();
	tw.tween_interval(delay);
	await tw.finished;
	tw.kill();

static func wait_function(obj : Node, delay : float, foo : Callable):
	var tw = obj.create_tween();
	tw.tween_interval(delay);
	tw.tween_callback(foo);
	await tw.finished;
	tw.kill();
