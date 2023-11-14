extends Node2D

@onready var _audiostreamer = $AudioStreamPlayer;

@export var volume : float = -10;
@export var _particles : CPUParticles2D;
@export var audios : Array[AudioStream];

func _ready() -> void:
	_audiostreamer.volume_db = volume;

func play(dir : int = 0):
	if _particles:
		_particles.direction.x = dir;
		_particles.emitting = true;
	
	_audiostreamer.stream = audios[randi() % audios.size()];
	_audiostreamer.play();
