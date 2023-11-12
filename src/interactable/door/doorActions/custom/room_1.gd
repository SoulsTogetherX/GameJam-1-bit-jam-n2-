extends DoorActions

var onTime : bool = false;

@export var thing : Thing:
	get:
		return _thing;
	set(val):
		_thing = val;

@export var arrow1 : Sprite2D;
@export var arrow2 : Sprite2D;

func _ready() -> void:
	super();
	
	var tw = arrow1.create_tween().set_loops();
	tw.tween_property(arrow1, "position:y", -92.5, 1.);
	tw.tween_property(arrow1, "position:y", -87.5, 1.);
	
	tw = arrow2.create_tween().set_loops();
	tw.tween_property(arrow2, "position:y", -87.5, 1.);
	tw.tween_property(arrow2, "position:y", -92.5, 1.);

func on_locked():
	_door.lockAnimation();
	if onTime:
		return;
	onTime = true;
	
	var tw = create_tween();
	tw.tween_property(_no, "modulate:a", 1., 1.);
	tw.tween_interval(1.); 
	tw.set_trans(Tween.TRANS_SPRING);
	tw.set_ease(Tween.EASE_IN_OUT);
	tw.tween_property(_thing.get_parent(), "rotation_degrees", 80, 1.);
	tw.tween_interval(0.2);
	tw.tween_callback(func(): 
		_thing.pause = false;
		_thing.hold = false;
		arrow1.modulate.a = 1;
		);
	
	await tw.finished;
	tw.kill();

func _on_thing_attached() -> void:
	arrow1.modulate.a = 0;
	arrow2.modulate.a = 1;

func _on_objective() -> void:
	_door.close();

func _on_objective_undo() -> void:
	_door.lock();

func on_closed():
	_door.open()
