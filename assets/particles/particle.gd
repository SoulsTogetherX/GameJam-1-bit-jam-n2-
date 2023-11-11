class_name BurstCPUParticles2D extends CPUParticles2D

var timer : Timer;

func _ready() -> void:
	timer = Timer.new();
	add_child(timer);
	timer.one_shot = true;
	timer.wait_time = lifetime;
	timer.start();
	timer.connect("timeout", queue_free);
	
	emitting = true;
