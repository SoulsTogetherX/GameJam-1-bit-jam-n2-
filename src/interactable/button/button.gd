@tool
extends Node2D

@export var other_way : bool = false;

@onready var unpushed : Sprite2D = $unpushed;
@onready var pushed   : Sprite2D = $pushed;
@onready var push_area: Area2D   = $push_area;

var state : bool = false;

@export var connected : Array[Node];
@export var me_offset : Vector2;
@export var connected_offset : Vector2;

func _draw() -> void:
	for con in connected:
		if con is Node2D:
			var you = to_local(con.global_position);
			var to_from : Vector2;
			
			if other_way:
				to_from = Vector2(you.x, 0);
			else:
				to_from = Vector2(0, you.y);
			
			draw_line(Vector2.ZERO, to_from, Color.WHITE, 0.9);
			draw_line(Vector2.ZERO, to_from, Color.BLACK, 0.6);
			draw_line(Vector2.ZERO, to_from, Color.WHITE, 0.3);
			
			draw_line(to_from, you, Color.WHITE, 0.9);
			draw_line(to_from, you, Color.BLACK, 0.6);
			draw_line(to_from, you, Color.WHITE, 0.3);

func _process(delta: float) -> void:
	queue_redraw();

func _ready() -> void:
	pushed.visible = false;
	unpushed.visible = true;

func _on_push_area_body_entered(body: Node2D) -> void:
	if !state:
		state = true;
		pushed.visible = true;
		unpushed.visible = false;
		for con in connected:
			con.disabled = !con.disabled;

func _on_push_area_body_exited(body: Node2D) -> void:
	if state && push_area.get_overlapping_bodies().size() == 0:
		state = false;
		pushed.visible = false;
		unpushed.visible = true;
		for con in connected:
			con.disabled = !con.disabled;
