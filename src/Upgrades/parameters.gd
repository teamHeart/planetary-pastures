class_name Parameters
extends Object

## Little Green related parameters
static var _little_green_move_speed: float = 100.0
static var _little_green_planting_speed_multiplier: float = 1.0
static var _little_green_harvesting_speed_multiplier: float = 1.0
static var _little_green_carry_capacity: int = 5

static func get_little_green_move_speed() -> float:
	return _little_green_move_speed
static func set_little_green_move_speed(speed: float) -> void:
	_little_green_move_speed = speed

static func get_little_green_planting_speed_multiplier() -> float:
	return _little_green_planting_speed_multiplier
static func set_little_green_planting_speed_multiplier(multiplier: float) -> void:
	_little_green_planting_speed_multiplier = multiplier

static func get_little_green_harvesting_speed_multiplier() -> float:
	return _little_green_harvesting_speed_multiplier
static func set_little_green_harvesting_speed_multiplier(multiplier: float) -> void:
	_little_green_harvesting_speed_multiplier = multiplier

static func get_little_green_carry_capacity() -> int:
	return _little_green_carry_capacity
static func set_little_green_carry_capacity(capacity: int) -> void:
	_little_green_carry_capacity = capacity