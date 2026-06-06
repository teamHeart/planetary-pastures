class_name StateMachine
extends Node


var _current_state: State = null

@onready var _operator: Variant = null

func set_operator(operator: Variant) -> void:
    _operator = operator

func change_state(new_state: State) -> void:
    if _current_state != null and _current_state != new_state and new_state != null:
        _current_state.exit.call(_operator)
        _current_state = new_state
        _current_state.enter.call(_operator)

func _process(delta: float) -> void:
    if _current_state != null:
        _current_state.process.call(_operator, delta)

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