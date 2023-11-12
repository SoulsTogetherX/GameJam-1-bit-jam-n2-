class_name No extends Dragable

@export var door : DoorActions;
@export var connected : Node;
@export var me_offset : Vector2;
@export var connected_offset : Vector2;

var thing : Thing;

var state       : bool = true;

func _ready() -> void:
	if connected:
		connected.disabled = state;
	pause = true;

func _draw() -> void:
	if connected is Node2D:
		var me = actor.position + me_offset;
		var you = connected.global_position - position + connected_offset;
		
		var to_from = Vector2(me.x, you.y);
		draw_line(me, to_from, Color.WHITE, 1.5);
		draw_line(me, to_from, Color.BLACK, 1.0);
		draw_line(me, to_from, Color.WHITE, 0.5);
		
		draw_line(to_from, you, Color.WHITE, 1.5);
		draw_line(to_from, you, Color.BLACK, 1.0);
		draw_line(to_from, you, Color.WHITE, 0.5);

func _physics_process(delta: float) -> void:
	super(delta);
	queue_redraw();

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	super(viewport, event, shape_idx);
	if !attached && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed():
		match actor.text:
			"Yes":
				state = true;
				actor.text = "No";
			"No":
				state = false;
				actor.text = "Yes";
			"Yesthing?":
				state = false;
				actor.text = "Yes";
				thing.visible = true;
				thing.global_position = actor.global_position;
				thing.global_position.x += 50;
				thing.hold = true;
				thing.actor.velocity = Vector2.ZERO;
				hold = true;
				thing.pause = false;
			"Nothing":
				state = true;
				actor.text = "No";
				thing.visible = true;
				thing.global_position = actor.global_position;
				thing.global_position.x += 50;
				thing.hold = true;
				thing.actor.velocity = Vector2.ZERO;
				hold = true;
				thing.pause = false;
				door.objective_undo.emit();
		actor.get_node("Area2D/CollisionShape2D").shape.extents = actor.get_rect().size * 0.5;
		connected.disabled = state;

func _input(event: InputEvent) -> void:
	if pause:
		return;
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		for c in actor.get_node("Area2D").get_overlapping_bodies():
			if c.owner is Thing && c.owner.visible:
				actor.text += "thing";
				actor.get_node("Area2D/CollisionShape2D").shape.extents = actor.get_rect().size * 0.5;
				thing = c.owner;
				thing.visible = false;
				thing.pause = true;
				thing.attached = false;
				if actor.text == "Nothing":
					door.objective.emit();
				else:
					actor.text = "Yesthing?";
				hold = true;
				state = false;
				return;	
