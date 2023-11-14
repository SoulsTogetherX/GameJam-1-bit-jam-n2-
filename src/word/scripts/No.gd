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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		for c in actor.get_node("Area2D").get_overlapping_areas():
			if c.owner is Thing && c.owner.visible:
				attach_thing(c.owner);
				return;	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	super(viewport, event, shape_idx);
	
	if !attached && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed():
		match actor._text:
			"Yes":
				state = true;
				actor.set_text("No")
			"No":
				state = false;
				actor.set_text("Yes")
			"Yesthing?":
				state = false;
				actor.set_text("Yes")
				thing.visible = true;
				thing.actor.global_position = actor.global_position;
				thing.actor.global_position.y -= 25;
				thing.hold = true;
				thing.actor.velocity = Vector2.ZERO;
				thing.actor.global_rotation = 0;
				hold = true;
				thing.pause = false;
			"Nothing":
				state = true;
				actor.set_text("No")
				thing.visible = true;
				thing.actor.global_position = actor.global_position;
				thing.actor.global_position.y -= 25;
				thing.hold = true;
				thing.actor.velocity = Vector2.ZERO;
				thing.actor.global_rotation = 0;
				hold = true;
				thing.pause = false;
				door.objective_undo.emit();
		actor.get_node("Area2D/CollisionShape2D").shape.extents = actor.get_rect().size * 0.5;
		if connected:
			connected.disabled = state;

func attach_thing(thing_ : Thing):
	
	
	actor.set_text(actor._text + "thing");
	actor.get_node("Area2D/CollisionShape2D").shape.extents = actor.get_rect().size * 0.5;
	thing = thing_;
	thing.visible = false;
	thing.pause = true;
	thing.attached = false;
	if actor._text == "Nothing":
		door.objective.emit();
	else:
		actor.set_text("Yesthing?");
	hold = true;
	state = false;
