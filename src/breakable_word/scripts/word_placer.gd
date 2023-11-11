@tool
class_name WordPlacer extends Node2D

static var globalStuff = load("res://global/global_stuff.gd");
var _area            : Rect2            = Rect2(global_position, Vector2.ZERO);
var _markers         : Array[Area2D]    = [];
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

func drop(idx: int) -> void:
	if _markers.size() > 1:
		_markers[idx].queue_free()
		_markers.pop_at(idx);
	else:
		_markers[idx].position.x = _segment_width() * 2;
	_segments.pop_at(idx);
	_segments[idx].drop();
	
	update_segments();

func drops(segments: Array[int]) -> void:
	for idx in segments:
		if _markers.size() > 1:
			_markers[idx].queue_free()
			_markers.pop_at(idx);
		else:
			_markers[idx].position.x = _segment_width() * 0.5;
		_segments.pop_at(idx);
		_segments[idx].drop();
	
	update_segments();

func drop_this(segment : Segment) -> void:
	for s in _segments:
		if segment == s:
			var idx = _segments.find(segment)
			if _markers.size() > 1:
				_markers[idx].queue_free()
				_markers.pop_at(idx);
			else:
				_markers[idx].position.x = _segment_width() * 0.5;
			_segments.pop_at(idx);
			segment.drop();
	
	update_segments();

func add_marker(height : int, idx : int) -> void:
	var marker = Area2D.new();
	var colide = CollisionShape2D.new();
	var shape  = RectangleShape2D.new();
	marker.collision_layer = 4;
	marker.collision_mask = 0;
	marker.position = Vector2(0, 0)
	colide.set_shape(shape);
	shape.extents = Vector2(1, height * 0.5);
	
	marker.add_child(colide);
	add_child(marker);
	_markers.append(marker);

func add_segment(seg : Segment, idx : int = -1) -> void:
	if idx == -1:
		idx = _segments.size() - 1;
		_segments.append(seg);
	else:
		_segments.insert(idx, seg);
	globalStuff.swap_parent(seg, self);
	if _segments.size() > _markers.size():
		add_marker(seg.get_height(), idx);
	update_segments();

func has_segment(seg : Segment) -> bool:
	return _segments.has(seg);

func find_area(area : Area2D) -> int:
	return _markers.find(area);

func update_segments() -> void:
	if _segments.is_empty():
		_area = Rect2();
		return;
	
	var width = _segment_width();
	_area.size = Vector2(width, _segments[0].get_height()) * 0.5;
	_area.position = Vector2.ZERO;
	
	var offset = Vector2(-width * 0.5, 0);
	for idx in _segments.size():
		var seg = _segments[idx];
		seg.position = offset;
		var w = seg.get_width();
		seg.position.x += w * 0.5;
		_markers[idx].position.x = w * 0.5;
		offset.x += w;
	
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
	
	globalStuff.waggle(self, 0.4);
