@tool
class_name Spawner extends Node

static var globalStuff;
static var _font             : Font;
static var _font_size        : float;
func _enter_tree() -> void:
	globalStuff = load("res://global/global_stuff.gd");
	_font = globalStuff.segment_font;
	_font_size = globalStuff.segment_font_size;

@export_multiline var text : String = "":
	set(val):
		text = val;
		if get_parent() != null:
			_parse_test(val);
var _placers : Array[WordPlacer] = [];
var spacing : int = 0;

func _parse_test(raw_text : String) -> void:
	if raw_text.is_empty():
		return;
	
	_destroy_placers();
	var txt    := raw_text.strip_edges();
	var strs   := txt.split("/", false);

	var offset : Vector2 = Vector2(-_word_width_strs(strs), 0);
	offset.x   *= 0.5;

	for str in strs:
		var placer : WordPlacer = _create_placer(str);
		var size_x = placer.get_width();
		
		placer.position = offset;
		placer.position.x += size_x;
		
		offset.x += size_x * 2 + spacing;

func _word_width_strs(strs : PackedStringArray) -> float:
	var width = 0;
	for str1 in strs:
		for str2 in str1.split("\\", false):
			width += _font.get_string_size(str2, HORIZONTAL_ALIGNMENT_CENTER, -1, _font_size).x;
	return width;

func _create_placer(txt : String) -> WordPlacer:
	var curr_placer = WordPlacer.create(get_parent(), txt);
	_placers.append(curr_placer);
	return curr_placer;

func _destroy_placers() -> void:
	for placer in _placers:
		placer.queue_free();
	_placers = [];
