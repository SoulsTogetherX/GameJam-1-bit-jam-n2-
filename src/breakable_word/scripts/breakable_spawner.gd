@tool
class_name Spawner extends Node

static var globalStuff = load("res://global/global_stuff.gd");
@onready var _font      : Font   = globalStuff.segment_font;
@onready var _font_size : float  = globalStuff.segment_font_size;

var text : String = "":
	set(val):
		text = val;
		_from_text();
var _placers : Array[WordPlacer] = [];
var _isReady : bool = false;

func update_placers():
	for placer in _placers:
		placer.update_segments();

func update_text() -> String:
	var txt : String = "";
	for placer in _placers:
		txt += placer.get_text();
	text = txt;
	_from_text();
	return txt;

func insert(idx : int, segment : Segment) -> String:
	var txt : String = "";
	for i in idx:
		txt += _placers[i].get_text() + "/";
	txt += segment.get_text() + "/";
	segment.destroy();
	for i in range(idx, _placers.size(), 1):
		txt += _placers[i].get_text() + "/";
	
	text = txt;
	return text;

func remove_this(placer: WordPlacer) -> String:
	if _placers.size() > 1:
		var idx = _placers.find(placer);
		_placers[idx].queue_free();
		_placers.remove_at(idx);
		return update_text();
	return _placers[0].get_text();

func remove(placer: int) -> void:
	if _placers.size() > 1:
		_placers[placer].queue_free();
		_placers.remove_at(placer);

func added_front(placer : WordPlacer, segment : Segment) -> String:
	var idx = _placers.find(placer);
	if idx != -1 && segment && !_placers.has(segment):
		return insert(idx + 1, segment);

	return text;

func added_behind(placer : WordPlacer, segment : Segment) -> String:
	var idx = _placers.find(placer);
	if idx != -1 && segment && !_placers.has(segment):
		return insert(idx, segment);

	return text;

func has(segment : Segment) -> bool:
	return _placers.has(segment);

func drop(placer: int) -> void:
	_placers[placer].drop();
	remove(placer);

func drops(placers: Array[int]) -> void:
	for placer in placers:
		drop(placer)

func _ready() -> void:
	await owner.ready;
	_from_text();
	_isReady = true;

func _from_text() -> void:
	_destroy_placers();
	var txt    := text.strip_edges();
	var strs   := txt.split("/", false);
	var offset : Vector2 = Vector2(-_font.get_string_size(txt, HORIZONTAL_ALIGNMENT_CENTER, -1, _font_size).x, 0);
	offset.x   += _font.get_char_size(47, _font_size).x * txt.count("/");
	offset.x   *= 0.5;
	
	var space_length : float = _font.get_char_size(32, _font_size).x;;
	var curr_placer : WordPlacer = _create_placer();
	var needNew : bool = false;
	
	for str in strs:
		var segments := str.split(" ");
		for seg in segments:
			if needNew:
				curr_placer.position.x += curr_placer.get_width();
				curr_placer = _create_placer();
				needNew = false;
			if seg == "":
				offset.x += space_length;
				continue;
			
			var newSeg : Segment = Segment.create(seg, _font, _font_size);
			curr_placer.add_segment(newSeg);
			curr_placer.position = offset;
			
			var size : float = _font.get_string_size(seg, HORIZONTAL_ALIGNMENT_CENTER, -1, _font_size).x;
			offset.x += size + space_length;
			
			needNew = true;
		
		offset.x -= space_length;
	curr_placer.position.x += curr_placer.get_width();

func _create_placer() -> WordPlacer:
	var curr_placer = WordPlacer.create();
	owner.add_child(curr_placer);
	_placers.append(curr_placer);
	return curr_placer;

func _destroy_placers() -> void:
	for placer in _placers:
		placer.queue_free();
	_placers = [];
