class_name StateMachine
extends Node


## Formatted [br]{[param NAME][lb][i]String[/i][rb]:
## [param state][lb][i]State[/i][rb], ...}[br]
## [b]Parameters:[/b][br]
## [param NAME] should be in constant case and match the name of the state for ease of use.
## [br][param State] should be a State object.[br]
## [b]NOTES:[/b][br]
## - The state machine does not manage the lifecycle of the states,
## so they should be created and managed externally.[br]
## - Always initiated with a blank [param NULL] state to avoid null reference errors.[br]
## - The NULL state acts as a safe default state and should not perform any actions.
var states: Dictionary = {"NULL": State.new()}
var _current_state: State = null

@onready var _operator: Variant = null

func _ready() -> void:
	# Set the initial state to IDLE
	set_state(states["NULL"])

func set_operator(operator: Variant) -> void:
	_operator = operator
	
## Adds a new state to the state machine.[br]
## [b]Parameters:[/b][br]
## [param name] should be a String representing the name of the state.[br]
## [param state] should be a State object.
func add_state(_name: String, _state: State) -> void:
	states[_name] = _state

## Changes the current state to the new state.
## If the new state is different from the current state,
## the current state's exit callable is called,
## and the new state's enter callable is called.[br]
## [b]Parameters:[/b][br]
## [param new_state] should be a State object.
func change_state(_new_state: State) -> void:
	var changed: bool = _new_state != _current_state
	if _current_state != null:
		_current_state.exit.call()
	if changed:
		_current_state = _new_state
		if _current_state != null:
			_current_state.enter.call()

## Sets the current state directly without calling the exit or enter callables.[br] 
## [b]Parameters:[/b][br]
## [param _state] should be a State object.
func set_state(_state: State) -> void:
	_current_state = _state

## Processes the current state.
## Called every frame with the delta time since the last frame.[br]
## If there is a current state, its process callable is called with the delta time.
func _process(delta: float) -> void:
	if _current_state != null:
		_current_state.process.call(delta)

class State:
	## Represents a state within the state machine.
	## Contains callables for enter, process, and exit actions.

	## Callable that is called when the state is entered.
	var _enter : Callable = func()-> void: pass

	## Callable that is called every frame while the state is active.
	var process : Callable = func(_delta: float)-> void: pass

	## Callable that is called when the state is exited.
	var _exit : Callable = func()-> void: pass

	## Sets the enter callable for the state.
	## [b]Parameters:[/b][br]
	## [param _en] should be a Callable object.
	func set_enter(_en: Callable) -> void:
		self._enter = _en

	## Sets the process callable for the state.
	## [b]Parameters:[/b][br]
	## [param _pr] should be a Callable object.
	func set_process(_pr: Callable) -> void:
		self.process = _pr

	## Sets the exit callable for the state.
	## [b]Parameters:[/b][br]
	## [param _ex] should be a Callable object.
	func set_exit(_ex: Callable) -> void:
		self._exit = _ex
