class_name Settings
extends Object

## Singleton class to hold game settings

enum ControlType { KBM = 1, CONTROLLER = 2, HYBRID = 3 }

static var _instance: Settings = null:
	get:
		return _instance
	set(value):
		assert(_instance == null, "Trying to reassign Settings singleton!!")
		_instance = value

var control_type: ControlType = ControlType.HYBRID


static func instance() -> Settings:
	if _instance == null:
		_instance = Settings.new()
	return _instance
