@tool
extends Node2D

var _font                  : Font   = ThemeDB.fallback_font;
var _font_size             : float  = 16;

var _text                  : String = "";
@export_multiline var text : String = "":
	get:
		return _text;
	set(val):
		_text = val;
		_from_text();
var _letters : Array[Segment] = [];

func _from_text() -> void:
	_destroy_all();
	_letters   = [];
	var strs   := _text.split("/", false);
	var offset : Vector2 = Vector2(-_font.get_string_size(_text, HORIZONTAL_ALIGNMENT_CENTER, -1, _font_size).x, 0);
	offset.x   += _font.get_char_size(47, _font_size).x * _text.count("/");
	offset.x   *= 0.5;
	
	var space_length : float = _font.get_char_size(32, _font_size).x;;
	
	for str in strs:
		var segs := str.split(" ");
		for seg in segs:
			if seg == "":
				offset.x += space_length;
				continue;
			
			var newSeg : Segment = await Segment.create(seg, _font, _font_size);
			_letters.append(newSeg);
			add_child(newSeg);
			newSeg.position = offset;
			var size : float = _font.get_string_size(seg, HORIZONTAL_ALIGNMENT_CENTER, -1, _font_size).x;
			newSeg.position.x += size * 0.5;
			offset.x += size + space_length;
		offset.x -= space_length;
	
func _destroy_all():
	for letters in _letters:
		letters.queue_free();
