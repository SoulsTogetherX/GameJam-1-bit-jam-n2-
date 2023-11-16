@tool
extends Node2D

@export var other_way : bool = false;

@onready var off_sprite : Sprite2D = $on_sprite;
@onready var on_sprite : Sprite2D = $off_sprite;
@onready var sound : Node2D = $sound_emiter;

var state : bool = false;
@export var connected : Array[Node];
@export var me_offset : Vector2;
@export var connected_offset : Vector2;

func _draw() -> void:
	return;
	for con in connected:
		if con is Node2D:
			var you = to_local(con.global_position);
			var to_from : Vector2;
			
			if other_way:
				to_from = Vector2(you.x, 0);
			else:
				to_from = Vector2(0, you.y);
			draw_line(Vector2.ZERO, to_from, Color.BLACK, 1.0);
			draw_line(Vector2.ZERO, to_from, Color.WHITE, 0.5);
				
			draw_line(to_from, you, Color.BLACK, 1.0);
			draw_line(to_from, you, Color.WHITE, 0.5);

func _process(delta: float) -> void:
	#queue_redraw();
	pass;

func _ready() -> void:
	if state:
		off_sprite.visible = false;
	else:
		on_sprite.visible = false;

func action():
	state = !state;
	sound.play();
	for con in connected:
		con.disabled = !con.disabled;
	if state:
		off_sprite.visible = false;
		on_sprite.visible = true;
	else:
		off_sprite.visible = true;
		on_sprite.visible = false;
