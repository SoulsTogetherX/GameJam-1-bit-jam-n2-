extends Node2D

@onready var _audiostreamer = $AudioStreamPlayer;

@export var volume : float = -10;
@export var _particles : CPUParticles2D = null;
@export var audios : Array[AudioStream];

func _ready() -> void:
	_audiostreamer.volume_db = volume;

func play(dir : int = 0):
	if _particles != null:
		_particles.direction.x = dir;
		_particles.emitting = true;
	
	BackgroundMusic.play_found_efx(_audiostreamer, audios[randi() % audios.size()], volume + 10);
