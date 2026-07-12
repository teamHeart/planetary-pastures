@abstract class_name Action
extends Resource

## Abstract Base class for actions that can be added to
## the action queues of Little Green and the Space Buns.

@warning_ignore("unused_signal")
signal action_completed

## Icon representing the action in the UI.
## This should be set by subclasses to provide a visual representation
## of the action when displayed in the game's user interface.
var icon: Texture2D = null

## The node that this action is associated with
var object: Node = null


func _init(_object: Node) -> void:
	action_completed.connect(Callable(self, "_on_completed"))
	object = _object



func execute(_delta: float) -> void:
	pass


func _on_completed() -> void:
	free()
