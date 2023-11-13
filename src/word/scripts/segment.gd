@tool
class_name Segment extends CharacterBody2D

static var globalStuff;
static var _font             : Font;
static var _font_size        : float;
func _enter_tree() -> void:
	globalStuff = load("res://global/global_stuff.gd");
	_font = globalStuff.segment_font;
	_font_size = globalStuff.segment_font_size;

var _collide                 : CollisionShape2D;
@onready var _label          : Label     = $Label;

var _text                    : String    = "";
@export var text             : String    = "":
	get:
		return _text;
	set(val):
		if !isReady:
			await ready;
		set_text(val);

var isReady : bool = false;
func _ready() -> void:
	_set_up();
	set_text(_text);
	isReady = true;

func _set_up() -> void:
	var shape = RectangleShape2D.new();
	_collide = CollisionShape2D.new();
	_collide.set_shape(shape);
	add_child(_collide);
	
	var _collide2 = CollisionShape2D.new();
	_collide2.set_shape(shape);
	$CollisionShape2D.add_child(_collide2);
	_collide2.one_way_collision = true;
	
	shape.extents.x = max(1, shape.extents.x);
	shape.extents.y = max(10, shape.extents.y);
	
	_label = $Label;

func get_text() -> String:
	return _text;

func set_text(txt : String) -> Segment:
	_text = txt;
	var size = _font.get_string_size(txt, HORIZONTAL_ALIGNMENT_CENTER, -1, _font_size) * 0.5;
	_collide.shape.extents = size;
	_collide.shape.extents.y *= 0.5;
	_label.text = txt;
	_label.position = -size;
	_label.position.y -= 1;
	
	return self;

func get_rect() -> Rect2:
	return _collide.shape.get_rect();

func get_width() -> float:
	return get_rect().size.x;

func get_height() -> float:
	return get_rect().size.y;
