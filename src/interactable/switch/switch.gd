@tool
extends Node2D

@onready var off_sprite : Sprite2D = $on_sprite;
@onready var on_sprite : Sprite2D = $off_sprite;

var state : bool = false;
@export var connected : Node;
@export var me_offset : Vector2;
@export var connected_offset : Vector2;

func _draw() -> void:
	if connected is Node2D:
		var me = global_position - position;
		var you = connected.global_position - global_position;
		
		var to_from = Vector2(me.x, you.y);
		draw_line(me, to_from, Color.WHITE, 1.5);
		draw_line(me, to_from, Color.BLACK, 1.0);
		draw_line(me, to_from, Color.WHITE, 0.5);
		
		draw_line(to_from, you, Color.WHITE, 1.5);
		draw_line(to_from, you, Color.BLACK, 1.0);
		draw_line(to_from, you, Color.WHITE, 0.5);

func _process(delta: float) -> void:
	queue_redraw();

func _ready() -> void:
	state = connected.disabled;
	if state:
		off_sprite.visible = false;
	else:
		on_sprite.visible = false;

func action():
	state = !state;
	connected.disabled = state;
	if state:
		off_sprite.visible = false;
		on_sprite.visible = true;
	else:
		off_sprite.visible = true;
		on_sprite.visible = false;
