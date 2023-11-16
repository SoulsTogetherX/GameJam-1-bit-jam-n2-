class_name Shooter extends Node2D

@export var dir = 1;
@export var shoot_time: float = 0.5;

@onready var timer: Timer = $Timer;
@onready var marker_2d: Marker2D = $Marker2D;

func _ready() -> void:
	timer.wait_time = shoot_time;
	timer.start();

func _on_timer_timeout() -> void:
	
	
	pass # Replace with function body.
