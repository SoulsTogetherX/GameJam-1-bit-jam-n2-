@tool
class_name CameraFollow extends Camera2D

@export var _follow : CharacterBody2D = null:
	set(val):
		_follow = val;
		if val != null:
			update_position();

@onready var decay_time : Timer = $decay_time;

# camera_bounds
const MAX_HEIGHT_RANGE : int   = 100;
const DESIRED_HEIGHT   : float = 20.;
const HEIGHT_LERP      : float = 0.1;
const MAX_WIDTH_RANGE  : int   = 100;
const DESIRED_WIDTH    : float = 0.;
const WIDTH_LERP       : float = 0.1;

#camera_shake
var _rng : RandomNumberGenerator = RandomNumberGenerator.new();
var _stength : Vector3 = Vector3.ZERO;
var _decay_spd : Vector3 = Vector3.ZERO;

func update_position():
	if !_follow:
		return;
	
	var diff_x = position.x - _follow.position.x;
	var diff_y = position.y - _follow.position.y;
	
	if abs(diff_y) > MAX_HEIGHT_RANGE:
		position.y = _follow.position.y + MAX_HEIGHT_RANGE * sign(diff_y);
	if abs(diff_y) > DESIRED_HEIGHT:
		var des_pos_y = _follow.position.y + DESIRED_HEIGHT * sign(diff_y);
		position.y = lerp(position.y, des_pos_y, HEIGHT_LERP);

	if abs(diff_x) > MAX_WIDTH_RANGE:
		position.x = _follow.position.x + MAX_WIDTH_RANGE * sign(diff_x);
	if abs(diff_x) > DESIRED_WIDTH:
		var des_pos_x = _follow.position.x + DESIRED_WIDTH * sign(diff_x);
		position.x = lerp(position.x, des_pos_x, WIDTH_LERP);

func shake(time : float, stength : Vector3, decay_spd : Vector3):
	if time <= 0:
		return;
	
	decay_time.wait_time = time;
	_stength = stength
	_decay_spd = decay_spd;
	
	if _decay_spd.x > 1:
		_decay_spd.x = 1;
	if _decay_spd.y > 1:
		_decay_spd.y = 1;
	if _decay_spd.z > 1:
		_decay_spd.z = 1;

func _process(_delta: float) -> void:
	if !_stength.is_zero_approx():
		var off = _random_offset();
		offset.x = off.x;
		offset.y = off.y;
		rotation_degrees = off.z;
		
		if decay_time.is_stopped():
			_stength.x = lerp(_stength.x, 0., _decay_spd.x);
			_stength.y = lerp(_stength.y, 0., _decay_spd.y);
			_stength.z = lerp(_stength.z, 0., _decay_spd.z);
	else:
		offset.x = 0;
		offset.y = 0;
		rotation = 0;

func _random_offset() -> Vector3:
	return Vector3(_rng.randf_range(-_stength.x, _stength.x), _rng.randf_range(-_stength.y, _stength.y), _rng.randf_range(-_stength.z, _stength.z));
