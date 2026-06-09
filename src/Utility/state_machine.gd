class_name StateMachine
extends Node


var _current_state: State = null

@onready var _operator: Variant = null

func set_operator(operator: Variant) -> void:
	_operator = operator

func change_state(new_state: State) -> void:
	var changed: bool = new_state != _current_state
	if _current_state != null:
		_current_state.exit.call()
	if changed:
		_current_state = new_state
		if _current_state != null:
			_current_state.enter.call()

func _process(delta: float) -> void:
	if _current_state != null:
		_current_state.process.call(delta)

class State:

	var enter : Callable = func()-> void: pass
	var process : Callable = func(_delta: float)-> void: pass
	var exit : Callable = func()-> void: pass
	func new() -> State:
		return self

	func set_enter(_enter: Callable) -> void:
		self.enter = _enter

	func set_process(_process: Callable) -> void:
		self.process = _process

	func set_exit(_exit: Callable) -> void:
		self.exit = _exit
