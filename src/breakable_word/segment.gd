@tool
class_name Segment extends Node2D

static var _font             : Font      = ThemeDB.fallback_font;
static var _font_size        : float     = 16;
var _collide : CollisionShape2D;
@onready var _label   : Label            = $Label;

var _text             : String           = "";
@export var text      : String           = "":
	get:
		return _text;
	set(val):
		if isReady:
			set_text(val);
		else:
			_text = val;

var isReady : bool = false;
func _ready() -> void:
	_collide = CollisionShape2D.new()
	_collide.set_shape(RectangleShape2D.new());
	add_child(_collide);
	
	set_text(_text);
	isReady = true;

static var instance = preload("res://src/breakable_word/segment.tscn");
static func create(text : String, font : Font = ThemeDB.fallback_font, font_size : int = 16) -> Segment:
	var seg        = instance.instantiate();
	seg.text       = text;
	seg._font      = font;
	seg._font_size = font_size;
	
	return seg;

func set_text(txt : String) -> Segment:
	_text = txt;
	var size = _font.get_string_size(txt, HORIZONTAL_ALIGNMENT_CENTER, -1, _font_size) * 0.5;
	_collide.shape.extents = size;
	_label.text = txt;
	_label.position = -size;
	
	return self;
