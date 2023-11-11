@tool
extends Node

static var segment_font      : Font = ThemeDB.fallback_font;
static var segment_font_size : int = 16;

static func swap_parent(node : Node, parent : Node) -> void:
	var pos : Vector2;
	if node is Node2D:
		pos = node.global_position;
	node.get_parent().remove_child(node);
	parent.add_child(node);
	if node is Node2D:
		node.global_position = pos;
