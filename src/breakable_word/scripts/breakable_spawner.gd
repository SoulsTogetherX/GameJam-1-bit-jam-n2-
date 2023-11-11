@tool
class_name Spawner extends Node

var _font                  : Font   = ThemeDB.fallback_font;
var _font_size             : float  = 16;

var text : String = "":
	set(val):
		text = val;
		_from_text();
var _letters : Array[Segment] = [];
var _placers : Array[WordPlacer] = [];

func update_placers():
	for placer in _placers:
		placer.update_segments();

func _from_text() -> void:
	_destroy_placers();
	_letters   = [];
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
			
			var newSeg : Segment = await Segment.create(seg, _font, _font_size);
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
