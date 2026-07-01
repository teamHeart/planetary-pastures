# gdlint:ignore = class-name
class_name WaterAction
extends Action

# Add any common properties or methods for action type here

var target_plot: GardenPlot = null


func _init(_object: Node, _target_plot: GardenPlot) -> void:
	super._init(_object)
	# Initialize any additional properties or perform setup based on the provided arguments
	target_plot = _target_plot


func execute(_delta: float) -> void:
	pass  # Implement the logic to execute the action based on its type and arguments
