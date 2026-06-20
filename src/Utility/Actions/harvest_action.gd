# gdlint:ignore = class-name
class_name HarvestAction
extends Action

# Add any common properties or methods for action type here
var target_plot: GardenPlot = null
var harvest_timer: Timer = Timer.new()

func _init(_object: Node, _target_plot: GardenPlot) -> void:
	super._init(_object)
	target_plot = _target_plot
	harvest_timer.wait_time = target_plot.current_plant.plant_details.plant_time
	harvest_timer.one_shot = true
	harvest_timer.connect("timeout", Callable(self, "_on_harvest_timer_timeout"))
	_object.add_child(harvest_timer)

func execute(_delta: float) -> void:
	if harvest_timer.is_stopped():
		harvest_timer.start()

func _on_harvest_timer_timeout() -> void:
	target_plot.harvest()
	emit_signal("action_completed")