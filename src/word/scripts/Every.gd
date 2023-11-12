class_name Every extends Dragable

@export var thing : Thing;

func _ready() -> void:
	super();
	var everyWith = GlobalStuff.segment_font.get_string_size($segment_.get_text(), HORIZONTAL_ALIGNMENT_CENTER, -1, GlobalStuff.segment_font_size).x;
	var thingWith = GlobalStuff.segment_font.get_string_size(thing.get_node("segment_").get_text(), HORIZONTAL_ALIGNMENT_CENTER, -1, GlobalStuff.segment_font_size).x;
	thing.global_position.y = global_position.y;
	thing.global_position.x = global_position.x + everyWith + thingWith;
	thing.hold = hold;
