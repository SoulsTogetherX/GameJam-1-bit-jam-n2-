@tool
class_name WordPlacer extends Node2D

@onready var _marker_back     : Area2D  = $front;
@onready var _marker_front    : Area2D  = $back;

static var globalStuff = load("res://global/global_stuff.gd");
var _area            : Rect2            = Rect2(global_position, Vector2.ZERO);
var _detect          : CollisionShape2D;
var _segment         : Segment;

static var instance = preload("res://src/breakable_word/objects/word_placer.tscn");
static func create() -> WordPlacer:
	var placer : WordPlacer = instance.instantiate();
	return placer;

func get_area() -> Rect2:
	return _area;

func get_width() -> float:
	return _area.size.x;

func get_height() -> float:
	return _area.size.y;

func drop() -> void:
	if !_segment:
		return;
	_segment.drop();
	_segment = null;
	
	update_segments();
	get_parent().empty(self);

func add_segment(seg : Segment, area : Area2D = null) -> void:
	if _segment:
		if area == null || area == _marker_front:
			print(seg.get_text())
			get_parent().added_front(self, seg);
		else:
			print(seg.get_text())
			get_parent().added_behind(self, seg);
		return;
	
	_segment = seg;
	globalStuff.swap_parent(seg, self);
	update_segments();
	return;

func get_text() -> String:
	if _segment:
		return _segment.get_text();
	return "";

func has_segment() -> bool:
	return _segment != null;

func update_segments() -> void:
	if !has_segment():
		_area = Rect2();
		return;
	
	var width                   = _segment.get_width();
	var height                  = _segment.get_height();
	
	_segment.position = Vector2(-width * 0.5, 0);
	_segment.position.x += width * 0.5;
	
	_area.size                  = Vector2(width, height) * 0.5;
	_area.position              = Vector2.ZERO;
	
	_detect.shape.extents   = _area.size;
	_detect.position = _area.position;
	
	_marker_back.get_child(0).shape.extents  =  Vector2(width * 0.25, height * 0.5);
	_marker_front.get_child(0).shape.extents =  Vector2(width * 0.25, height * 0.5);
	_marker_back.position.x       = -width * 0.25;
	_marker_front.position.x      =  width * 0.25;

func _set(property: StringName, value : Variant) -> bool:
	if property == "position":
		_area.position = value;

	return false;

func _ready() -> void:
	_detect = CollisionShape2D.new()
	_detect.set_shape(RectangleShape2D.new());
	_detect.modulate = Color.GREEN;
	$Area2D.add_child(_detect);
	
	var colide_front = CollisionShape2D.new();
	_marker_front.add_child(colide_front);
	
	var colide_back = CollisionShape2D.new();
	_marker_back.add_child(colide_back);
	
	var shape = RectangleShape2D.new()
	_marker_front.get_child(0).set_shape(shape);
	_marker_back.get_child(0).set_shape(shape);
	
	_marker_front.modulate = Color.PURPLE;
	_marker_back.modulate = Color.PURPLE;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		self.on_click();

static var click_particle = preload("res://assets/particles/click_text_particle.tscn");
func on_click():
	var particle = click_particle.instantiate();
	add_sibling(particle);
	particle.position = get_local_mouse_position() + position;
	
	globalStuff.waggle(self, 0.4);
