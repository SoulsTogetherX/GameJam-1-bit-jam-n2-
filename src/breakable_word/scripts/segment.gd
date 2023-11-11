@tool
class_name Segment extends RigidBody2D

const MAX_SPEED  : int = 20;

static var globalStuff = load("res://global/global_stuff.gd");
static var _font             : Font   = globalStuff.segment_font;
static var _font_size        : float  = globalStuff.segment_font_size;
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
		if isReady:
			set_text(val);
		else:
			_text = val;

var isReady : bool = false;
func _ready() -> void:
	hold();
	
	_collide = CollisionShape2D.new();
	var detect = CollisionShape2D.new();
	
	var shape = RectangleShape2D.new();
	_collide.set_shape(shape);
	detect.set_shape(shape);
	
	add_child(_collide);
	$Area2D.add_child(detect);
	
	set_text(_text);
	isReady = true;

func _process(delta: float) -> void:
	if attached:
		var move_vec = attached_offset + get_global_mouse_position() - global_position;
		if move_vec.length() > MAX_SPEED:
			move_vec = move_vec.normalized() * MAX_SPEED;
		move_and_collide(move_vec);

static var instance = preload("res://src/breakable_word/objects/segment.tscn");
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

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		if attached:
			attached = false;
			for area in $Area2D.get_overlapping_areas():
				var placer = area.get_parent();
				if placer is WordPlacer && !placer.has_segment(self):
					placer.add_segment(self, placer.find_area(area));
					return;
			drop();
			return;
		if can_move:
			var segments = get_tree().get_nodes_in_group("segment");
			for s in segments:
				if s.attached == true:
					return;
			
			attached = true;
			var max_offset = get_rect().size * 0.5 - Vector2(1, 1);
			attached_offset = (global_position - get_global_mouse_position()).clamp(-max_offset, max_offset);
			
			if get_parent() is WordPlacer:
				get_parent().drop_this(self);
			hold()

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
