@abstract class_name Action
extends Resource

## Abstract Base class for actions that can be added to
## the action queues of Little Green and the Space Buns.

@warning_ignore("unused_signal")
signal action_completed(action: Action)

var object: Node = null


func _init(_object: Node) -> void:
	object = _object


func execute(_delta: float) -> void:
	assert(false, "Execute method must be implemented by subclasses of Action")
