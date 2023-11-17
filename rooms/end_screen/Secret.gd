extends Node2D

@onready var audioPlayer : AudioStreamPlayer = $AudioStreamPlayer;
@onready var place = [
	load("res://assets/sound/word/place_1.wav"),
	load("res://assets/sound/word/place_2.wav"),
	load("res://assets/sound/word/place_3.wav"),
	load("res://assets/sound/word/place_4.wav")
];

static var click_particle = preload("res://assets/particles/click_text_particle_small.tscn");
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		var particle = click_particle.instantiate();
		add_child(particle);
		particle.global_position = get_global_mouse_position();
		GlobalStuff.waggle($".", 0.3, 5 * sign(get_local_mouse_position().x));
		if $"../falling_girl".is_on_floor():
			$"../falling_girl".collision_mask = 0;
		else:
			$"../falling_girl".collision_mask = 1;
		$"../falling_girl".process_mode = Node.PROCESS_MODE_INHERIT;
			
		audioPlayer.volume_db = -20;
		audioPlayer.stream = place[randi() % place.size()];
		audioPlayer.play();
