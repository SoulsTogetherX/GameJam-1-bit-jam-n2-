@tool
class_name WordPlacer extends Node2D

static var globalStuff;
var _font      : Font;
var _font_size : float;
func _enter_tree() -> void:
	globalStuff = load("res://global/global_stuff.gd");
	_font = globalStuff.segment_font;
	_font_size = globalStuff.segment_font_size;

var _area            : Rect2            = Rect2(global_position, Vector2.ZERO);
var _detect          : CollisionShape2D;
var _segments        : Array[Segment] = [];

@export_multiline var text : String = "":
	set(val):
		text = val;
		if !isReady:
			await ready;
		_parse_text(text);

static var _instance = preload("res://src/breakable_word/objects/word.tscn");
static func create(own : Node, txt : String) -> WordPlacer:
	var placer : WordPlacer = _instance.instantiate();
	own.add_child(placer);

	placer._parse_text(txt);
	return placer;

func get_area() -> Rect2:
	return _area;

func get_width() -> float:
	return _area.size.x;

func get_height() -> float:
	return _area.size.y;

func insert(str : String, idx : int = -1) -> void:
	if idx == -1:
		idx = _segments.size() - 1;
	
	str = str.replace("/", "");
	var txt : String = "";
	
	for i in range(0, idx, 1):
		txt += _segments[i].get_text() + "\\";
	txt += str + "\\";
	for i in range(idx, _segments.size(), 1):
		txt += _segments[i].get_text() + "\\";
	
	_parse_text(txt);

func get_text() -> String:
	var txt : String = "";
	for segment in _segments:
		txt += segment.get_text();
	return txt;

func get_text_raw() -> String:
	var txt : String = "";
	for segment in _segments:
		txt += segment.get_text() + "\\";
	return txt.left(-1);

func _parse_text(raw_text : String) -> void:
	if raw_text.is_empty():
		return;
	
	_destroy_segments();
	var txt    := raw_text.strip_edges();
	var strs   := txt.split("\\", false);
	var width   = _word_width_strs(strs);
	var offset : Vector2 = Vector2(-width * 0.5, 0);
	
	for str in strs:
		var size : float = _font.get_string_size(str, HORIZONTAL_ALIGNMENT_CENTER, -1, _font_size).x;
		
		var newSeg : Segment = Segment.create(str, _font, _font_size);
		_segments.append(newSeg);
		newSeg.position = offset;
		newSeg.position.x += size * 0.5;
		add_child(newSeg);
		
		offset.x += size;
	
	_area.size = Vector2(width, _segments[0].get_height()) * 0.5;
	_area.position = Vector2.ZERO;
	_detect.shape.extents   = _area.size;
	_detect.position = _area.position;

func _destroy_segments() -> void:
	for segment in _segments:
		segment.queue_free();
	_segments = [];

func _word_width_strs(strs : PackedStringArray) -> float:
	var width = 0;
	for str in strs:
		width += _font.get_string_size(str, HORIZONTAL_ALIGNMENT_CENTER, -1, _font_size).x;
	return width;

func _word_width() -> float:
	var width = 0;
	for segment in _segments:
		width += segment.get_width();
	return width;

func _set(property: StringName, value : Variant) -> bool:
	if property == "position":
		_area.position = value;

	return false;

var isReady : bool = false;
func _ready() -> void:
	if $Area2D.get_child_count() == 0:
		_detect = CollisionShape2D.new()
		_detect.set_shape(RectangleShape2D.new());
		_detect.modulate = Color.GREEN;
	
		$Area2D.add_child(_detect);
		_detect.owner = self;
	else:
		_detect = $Area2D.get_child(0);
	isReady = true;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		self.on_click();

static var click_particle = preload("res://assets/particles/click_text_particle.tscn");
func on_click():
	var particle = click_particle.instantiate();
	add_sibling(particle);
	particle.position = get_local_mouse_position() + position;
	
	globalStuff.waggle(self, 0.4);
