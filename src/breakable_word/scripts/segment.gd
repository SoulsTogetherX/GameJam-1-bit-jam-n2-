@tool
class_name Segment extends RigidBody2D

static var globalStuff;
static var _font             : Font;
static var _font_size        : float;
func _enter_tree() -> void:
	globalStuff = load("res://global/global_stuff.gd");
	_font = globalStuff.segment_font;
	_font_size = globalStuff.segment_font_size;

const MAX_SPEED  : int = 20;
static var noPickup : bool = false;

var _collide                 : CollisionShape2D;
var attached_offset          : Vector2;
var attached                 : bool = false;
var can_move                 : bool = true;
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
	hold();
	_set_up();
	set_text(_text);
	isReady = true;

func _set_up() -> void:
	var shape = RectangleShape2D.new();
	_collide = CollisionShape2D.new();
	_collide.set_shape(shape);
	add_child(_collide);
	_collide.owner = self;
	
	var detect = CollisionShape2D.new();
	detect.set_shape(shape);
	$Area2D.add_child(detect);
	detect.owner = self;
	
	_label = $Label;

func _process(delta: float) -> void:
	if attached:
		var move_vec = attached_offset + get_global_mouse_position() - global_position;
		if move_vec.length() > MAX_SPEED:
			move_vec = move_vec.normalized() * MAX_SPEED;
		move_and_collide(move_vec);

static var _instance = preload("res://src/breakable_word/objects/segment_.tscn");
static func create(text : String, font : Font = ThemeDB.fallback_font, font_size : int = 16) -> Segment:
	var seg        = _instance.instantiate();
	seg.text       = text;
	seg._font      = font;
	seg._font_size = font_size;
	
	return seg;

func destroy():
	if attached:
		noPickup = false;
	queue_free();

func get_text() -> String:
	return _text;

func set_text(txt : String) -> Segment:
	_text = txt;
	var size = _font.get_string_size(txt, HORIZONTAL_ALIGNMENT_CENTER, -1, _font_size) * 0.5;
	_collide.shape.extents = size;
	_label.text = txt;
	_label.position = -size;
	
	return self;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		pass;

func get_rect() -> Rect2:
	return _collide.shape.get_rect();

func get_width() -> float:
	return get_rect().size.x;

func get_height() -> float:
	return get_rect().size.y;

func hold():
	freeze = true;

func drop():
	globalStuff.swap_parent(self, get_tree().current_scene);
	freeze = false;
