@tool
extends Node2D

@export var other_way : bool = false;

@onready var unpushed : Sprite2D = $unpushed;
@onready var pushed   : Sprite2D = $pushed;
@onready var push_area: Area2D   = $push_area;
@onready var sound : Node2D = $sound_emiter;

var state : bool = false;

@export var connected : Array[Node];
@export var me_offset : Vector2;
@export var connected_offset : Vector2;
@export var show : bool = false;

func _draw() -> void:
	if !show:
		return;
	for con in connected:
		if con is Node2D:
			var you = to_local(con.global_position);
			var to_from : Vector2;
			
			if other_way:
				to_from = Vector2(you.x, 0);
			else:
				to_from = Vector2(0, you.y);
			draw_line(Vector2(0, -50), to_from + Vector2(10, -50), Color.BLACK, 20.);
			draw_line(Vector2(0, -50), to_from + Vector2(10, -50), Color.WHITE, 10.);
				
			draw_line(to_from + Vector2(0, -40), you, Color.BLACK, 20.);
			draw_line(to_from + Vector2(0, -40), you, Color.WHITE, 10.);

func _process(delta: float) -> void:
	if !show:
		return;
	queue_redraw();

func _ready() -> void:
	pushed.visible = false;
	unpushed.visible = true;

func _on_push_area_body_entered(body: Node2D) -> void:
	if !state:
		state = true;
		pushed.visible = true;
		unpushed.visible = false;
		sound.play();
		for con in connected:
			con.disabled = !con.disabled;

func _on_push_area_body_exited(body: Node2D) -> void:
	if state && push_area.get_overlapping_bodies().size() == 0:
		state = false;
		pushed.visible = false;
		unpushed.visible = true;
		sound.play();
		for con in connected:
			con.disabled = !con.disabled;
