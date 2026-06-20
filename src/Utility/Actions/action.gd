@abstract class_name Action
extends Resource

## Abstract Base class for actions that can be added to
## the action queues of Little Green and the Space Buns.

@warning_ignore("unused_signal")
signal action_completed

var object: Node = null


func _init(_object: Node) -> void:
	action_completed.connect(Callable(self, "_on_completed"))
	object = _object


func execute(_delta: float) -> void:
	pass

func _on_completed() -> void:
	free()
