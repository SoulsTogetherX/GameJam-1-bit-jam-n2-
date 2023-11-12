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

func _insert_update(str : String, placer : WordPlacer) -> void:
	var idx   : int = _placers.find(placer);
	var strs : PackedStringArray = text.split("/");
	
	var txt  : String = "";
	
	prints("6-:", [str]);
	
	for i in range(0, idx, 1):
		txt += strs[i] + "/";
		prints("7-:", [txt]);
	txt += str + "/";
	prints("8-:", [txt]);
	for i in range(idx + 1, strs.size(), 1):
		txt += strs[i] + "/";
		prints("9-:", [txt]);
	
	text = txt.left(-1);
	prints("10-:", [txt.left(-1)]);
	for p in _placers:
		for s in p._segments:
			print(s.get_text())

func drop(placer : WordPlacer, segment : Segment):
	globalStuff.swap_parent(segment, get_tree().current_scene);
	
	var idx1   : int = _placers.find(placer);
	var idx2   : int = _placers[idx1]._segments.find(segment);
	
	var strs1 : PackedStringArray = text.split("/");
	var strs2 : PackedStringArray = strs1[idx1].split("\\");
	
	var txt1  : String = "";
	var txt2  : String = "";
	
	for i in range(0, idx2, 1):
		txt2 += strs2[i] + "\\";
	for i in range(idx2 + 1, strs2.size(), 1):
		txt2 += strs2[i] + "\\";
	txt2 = txt2.left(-1);
	
	for i in range(0, idx1, 1):
		txt1 += strs1[i] + "/";
	txt1 += txt2 + "/";
	for i in range(idx1 + 1, strs1.size(), 1):
		txt1 += strs1[i] + "/";
	text = txt1.left(-1);

func _parse_test(raw_text : String) -> void:
	if raw_text.is_empty():
		return;
	
	_destroy_placers();
	var txt    := raw_text.strip_edges();
	var strs   := txt.split("/");

	var offset : Vector2 = Vector2(-_word_width_strs(strs), 0);
	offset.x   *= 0.5;
	
	prints("11-:", txt, strs);
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
	var curr_placer = WordPlacer.create(self, txt);
	_placers.append(curr_placer);
	return curr_placer;

func _destroy_placers() -> void:
	for placer in _placers:
		placer.queue_free();
	_placers = [];
