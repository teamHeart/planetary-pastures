class_name GardenPlot
extends Node2D

@warning_ignore_start("unused_signal")
signal plant_grown(plot_id: int)
signal plant_harvested(plot_id: int)
signal plant_planted(plant_type: PlantDetails.PlantType)

static var plot_counter: int = 0
static var current_tool: PlantDetails.PlantType = PlantDetails.PlantType.NONE

var growth_percent: float = 0.0

var plot_id: int = 0

@warning_ignore_start("unused_private_class_variable")
var _growth_time: float = 0.0
var _is_grown: bool = false

@onready var current_plant: Plant = $Plant
@onready var particle_emitter: CPUParticles2D = $Particles
@onready var area_2d: Area2D = $Area2D
@onready var growth_bar: ProgressBar = %GrowthBar
@onready var water_bar: ProgressBar = %WaterBar


func _enter_tree() -> void:
	# Ensure the plot_id is unique and correctly assigned
	plot_id = plot_counter
	name = "Plot_" + str(plot_id)
	plot_counter += 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plant(PlantDetails.PlantType.NONE)  # Initialize the plot with no plant
	# Set the initial scale of the sprites

	# setup the animation player
	particle_emitter.emitting = false
	growth_bar.value = 0.0
	growth_bar.visible = false
	water_bar.value = 0.0
	water_bar.visible = false

	# make clickable
	area_2d.connect("input_event", Callable(self, "_on_input_event"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_plant.plant_type == PlantDetails.PlantType.NONE:
		return
	if not _is_grown:
		_growth_time += delta
		match _growth_time:
			_ when _growth_time < current_plant.plant_details.gestation_time:
				water_bar.visible = true
				water_bar.value = min(
					(_growth_time / current_plant.plant_details.gestation_time) * 100.0, 100.0
				)

			_ when (
				_growth_time
				< (
					current_plant.plant_details.gestation_time
					+ current_plant.plant_details.growth_time
				)
			):
				growth_bar.visible = true
				growth_bar.value = (
					(
						(_growth_time - current_plant.plant_details.gestation_time)
						/ current_plant.plant_details.growth_time
					)
					* 100.0
				)
				current_plant._on_growing()
			_:
				water_bar.visible = false
				growth_bar.visible = false
				current_plant._on_grown()
				_is_grown = true
				particle_emitter.emitting = true
				emit_signal("plant_grown", plot_id)


func _get_details() -> PlantDetails:
	return current_plant.plant_details


func plant(_plant_type: PlantDetails.PlantType) -> void:
	current_plant.plant_type = _plant_type
	_growth_time = 0.0
	_is_grown = false
	current_plant._on_planted()
	plant_planted.emit(_plant_type)


func harvest() -> void:
	particle_emitter.emitting = false
	_is_grown = false
	current_plant._on_harvested()
	emit_signal("plant_harvested", plot_id)


func _on_input_event(_viewport, event, _shape_idx) -> void:
	if (
		event is InputEventMouseButton
		and event.pressed
		and event.button_index == MouseButton.MOUSE_BUTTON_LEFT
	):
		print("Plot ", plot_id, " clicked")

		if _is_grown:
			harvest()
		elif current_plant.plant_type == PlantDetails.PlantType.NONE:
			plant(current_tool)
