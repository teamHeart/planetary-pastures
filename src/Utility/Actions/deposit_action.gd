# gdlint:ignore = class-name
class_name DepositAction
extends Action

# Add any common properties or methods for action type here


func _init(_object: Node, _args: Dictionary) -> void:
	super._init(_object)
	# Initialize any additional properties or perform setup based on the provided arguments


func execute(_delta: float) -> void:
	pass  # Implement the logic to execute the action based on its type and arguments
