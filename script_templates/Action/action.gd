# meta-name: New Action Type
# meta-description: Template for creating a new action type that can be added to the action queues of Little Green and the Space Buns. This script should be extended to implement specific actions with their own logic and properties.
# meta-default: true

class_name _CLASS_
extends Action

# Add any common properties or methods for action type here


func _init(_object: Node, _args: Dictionary) -> void:
	super._init(_object)
	# Initialize any additional properties or perform setup based on the provided arguments


func execute(_delta: float) -> void:
	pass  # Implement the logic to execute the action based on its type and arguments
