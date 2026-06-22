# gdlint:ignore = class-name
class_name PlantAction
extends Action

# Add any common properties or methods for action type here
var target_plot: GardenPlot = null
var planting_timer: Timer = Timer.new()


func _init(_object: Node, _target_plot: GardenPlot) -> void:
	super._init(_object)
	target_plot = _target_plot
	planting_timer.wait_time = target_plot.current_plant.plant_details.plant_time
	planting_timer.one_shot = true
	planting_timer.connect("timeout", Callable(self, "_on_planting_timer_timeout"))
	_object.add_child(planting_timer)


func execute(_delta: float) -> void:
	if planting_timer.is_stopped():
		planting_timer.start()


func _on_planting_timer_timeout() -> void:
	target_plot.plant(target_plot.current_plant.plant_type)
	emit_signal("action_completed")
