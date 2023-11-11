@tool
class_name WordPlacer extends Node2D

var _area            : Rect2            = Rect2(global_position, Vector2.ZERO);
var _detect          : CollisionShape2D;
var _segments        : Array[Segment];

static var instance = preload("res://src/breakable_word/objects/word_placer.tscn");
static func create() -> WordPlacer:
	return instance.instantiate();

func get_area() -> Rect2:
	return _area;

func get_width() -> float:
	return _area.size.x;

func get_height() -> float:
	return _area.size.y;

func drop(segment: int) -> void:
	_segments[segment].drop();

func drops(segments: Array[int]) -> void:
	for idx in segments:
		_segments[idx].drop();

func add_segment(seg : Segment):
	add_child(seg);
	_segments.append(seg);
	update_segments();

func update_segments():
	if _segments.is_empty():
		_area = Rect2();
		return;
	
	var width = _segment_width();
	_area.size = Vector2(width, _segments[0].get_height()) * 0.5;
	_area.position = Vector2.ZERO;
	
	var offset = Vector2(-width * 0.5, 0);
	for seg in _segments:
		seg.position = offset;
		seg.position.x += seg.get_width() * 0.5;
		offset.x += seg.get_width();
	
	_detect.shape.extents   = _area.size;
	_detect.position = _area.position;

func _set(property: StringName, value : Variant) -> bool:
	if property == "position":
		_area.position = value;

	return false;

func _ready() -> void:
	_detect = CollisionShape2D.new()
	_detect.set_shape(RectangleShape2D.new());
	_detect.modulate = Color.GREEN;
	$Area2D.add_child(_detect);
	
func _segment_width() -> float:
	var width = 0;
	for seg in _segments:
		width += seg.get_width();
	return width;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		self.on_click();

static var click_particle = preload("res://assets/particles/click_text_particle.tscn");
func on_click():
	var particle = click_particle.instantiate();
	add_sibling(particle);
	particle.position = get_local_mouse_position() + position;
	
	waggle();

func waggle():
	var tw = create_tween();
	tw.tween_property(self, "rotation_degrees",  5, 0.05);
	tw.tween_property(self, "rotation_degrees", -5, 0.05);
	tw.tween_property(self, "rotation_degrees",  0, 0.05);
	tw.play();
	
	await tw.finished;
	tw.kill();
