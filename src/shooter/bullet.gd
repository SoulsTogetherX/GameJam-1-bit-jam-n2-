class_name Bullet extends Node2D

var _spd = 0;
var _dir = 0;

static var instant = preload("res://src/shooter/bullet.tscn");
static func create(own : Node, dir : int, spd : float) -> Bullet:
	var bullet = instant.instantiate();
	own.add_child(bullet);
	bullet._dir = sign(dir);
	bullet._spd = spd;
	return bullet;

func _physics_process(delta: float) -> void:
	pass
