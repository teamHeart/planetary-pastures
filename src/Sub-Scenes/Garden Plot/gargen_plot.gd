class_name GardenPlot
extends Node2D

@warning_ignore_start("unused_signal")
signal plot_clicked(plot: GardenPlot)
signal plant_grown(plot: GardenPlot)
signal plant_harvested(plant: PlantDetails)
signal plant_watered(plot: GardenPlot)
signal pland_sprouted(plot: GardenPlot)
signal plant_fertilized(plot: GardenPlot)
signal plant_planted(plant_type: PlantDetails.PlantType)

static var plot_counter: int = 0
static var current_tool: PlantDetails.PlantType = PlantDetails.PlantType.NONE

var growth_percent: float = 0.0

var plot_id: int = 0

#region State Machine setup
var state_machine: StateMachine = StateMachine.new()

#region Empty State
## State for when the plot is empty and ready for planting
var empty_state: StateMachine.State = StateMachine.State.new()
## This function is called when the EMPTY state is entered.
var empty_enter: Callable = func() -> void:
	# Clear out all the stuff and things
	is_planted = false
	is_watered = false
	is_fertilized = false
	is_grown = false
	current_plant.visible = false

## This function is called every frame while in the EMPTY state.
var empty_process: Callable = func(_delta: float) -> void:
	# Do nothing
	pass

## This function is called when the EMPTY state is exited.
var empty_exit: Callable = func() -> void:
	# Do nothing
	pass

#endregion Empty State

#region Planted State
## State for when a seed has been planted but has not yet sprouted
var planted_state: StateMachine.State = StateMachine.State.new()
## This function is called when the PLANTED state is entered.
var planted_enter: Callable = func() -> void:
	
	pass

## This function is called every frame while in the PLANTED state.
var planted_process: Callable = func(_delta: float) -> void:
	# You can add any code that should run continuously in the PLANTED state here.
	pass
## This function is called when the PLANTED state is exited.
var planted_exit: Callable = func() -> void:
	# You can add any cleanup code for the PLANTED state here.
	pass

#endregion Planted State

#region Growing State
## State for when the plant is growing but not yet fully grown
var growing_state: StateMachine.State = StateMachine.State.new()
## This function is called when the GROWING state is entered.
var growing_enter: Callable = func() -> void:
	# You can add any initialization code for the GROWING state here.
	pass

## This function is called every frame while in the GROWING state.
var growing_process: Callable = func(_delta: float) -> void:
	# You can add any code that should run continuously in the GROWING state here.
	pass

## This function is called when the GROWING state is exited.
var growing_exit: Callable = func() -> void:
	# You can add any cleanup code for the GROWING state here.
	pass

#endregion Growing State
 
#region Grown State
## State for when the plant is fully grown and ready to harvest
var grown_state: StateMachine.State = StateMachine.State.new()
## This function is called when the GROWN state is entered.
var grown_enter: Callable = func() -> void:
	# You can add any initialization code for the GROWN state here.
	pass

## This function is called every frame while in the GROWN state.
var grown_process: Callable = func(_delta: float) -> void:
	# You can add any code that should run continuously in the GROWN state here.
	pass

## This function is called when the GROWN state is exited.
var grown_exit: Callable = func() -> void:
	# You can add any cleanup code for the GROWN state here.
	pass

#endregion Grown State

#endregion State Machine setup

var is_planted: bool = false
var is_watered: bool = false
var watering_timer: Timer = Timer.new()
var is_sprouted: bool = false
var is_fertilized: bool = false
var fertilizing_timer: Timer = Timer.new()
var is_grown: bool = false

var growth_time: float = 0.0

@onready var current_plant: Plant = $Plant
@onready var particle_emitter: CPUParticles2D = $Particles
@onready var area_2d: Area2D = $Area2D
@onready var growth_bar: ProgressBar = %GrowthBar
@onready var water_bar: ProgressBar = %WaterBar
@onready var water_layer: Sprite2D = $WaterLayer
@onready var fertilizer_layer: Sprite2D = $FertilizerLayer
@onready var fertilizer_anim = %FertilizerAnim
@onready var water_anim = %WaterAnim


func _enter_tree() -> void:
	# Ensure the plot_id is unique and correctly assigned
	plot_id = plot_counter
	name = "Plot_" + str(plot_id)
	plot_counter += 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Create and set up the state machine with its states and callables
	#region State Machine Build
	#region Empty State Build
	state_machine.add_state("EMPTY", empty_state)
	empty_state.set_enter(empty_enter)
	empty_state.set_process(empty_process)
	empty_state.set_exit(empty_exit)
	#endregion Empty State Build
	#region Planted State Build
	state_machine.add_state("PLANTED", planted_state)
	planted_state.set_enter(planted_enter)
	planted_state.set_process(planted_process)
	planted_state.set_exit(planted_exit)
	#endregion Planted State Build
	#region Growing State Build
	state_machine.add_state("GROWING", growing_state)
	growing_state.set_enter(growing_enter)
	growing_state.set_process(growing_process)
	growing_state.set_exit(growing_exit)
	#endregion Growing State Build
	#region Grown State Build
	state_machine.add_state("GROWN", grown_state)
	grown_state.set_enter(grown_enter)
	grown_state.set_process(grown_process)
	grown_state.set_exit(grown_exit)
	#endregion Grown State Build
	state_machine.set_operator(self)
	state_machine.set_state(empty_state)
	#endregion State Machine Build

	plant(PlantDetails.PlantType.NONE)  # Initialize the plot with no plant
	is_watered = false
	is_fertilized = false
	is_grown = false
	is_planted = false

	# setup the animation player
	particle_emitter.emitting = false
	growth_bar.value = 0.0
	growth_bar.visible = false
	water_bar.value = 0.0
	water_bar.visible = false
	water_layer.visible = false
	fertilizer_layer.visible = false
	add_child(watering_timer)
	watering_timer.one_shot = true
	watering_timer.connect(
		"timeout",
		func() -> void:
			is_watered = true
			emit_signal("plant_watered", self)
			water_anim.stop()
			water_anim.visible = false
	)
	water_anim.stop()
	water_anim.visible = false
	add_child(fertilizing_timer)
	fertilizing_timer.one_shot = true
	fertilizing_timer.connect(
		"timeout",
		func() -> void:
			is_fertilized = true
			emit_signal("plant_fertilized", self)
			fertilizer_anim.stop()
			fertilizer_anim.visible = false
	)
	fertilizer_anim.stop()
	fertilizer_anim.visible = false

	# make clickable
	area_2d.connect("input_event", Callable(self, "_on_input_event"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	pass
	# Deprecated: State machine processing is now handled within the state machine itself,
	# so we no longer need to call it here.
#region deprecated state machine processing
	# water_layer.visible = is_watered
	# fertilizer_layer.visible = is_fertilized
	# current_plant.visible = is_planted
	# if not is_planted:
	# 	return
	# if current_plant.plant_type == PlantDetails.PlantType.NONE:
	# 	return
	# if not is_grown:
	# 	growth_time += delta
	# 	match growth_time:
	# 		_ when growth_time < current_plant.plant_details.gestation_time:
	# 			if is_watered:
	# 				growth_time += delta
	# 			water_bar.visible = true
	# 			water_bar.value = min(
	# 				(growth_time / current_plant.plant_details.gestation_time) * 100.0, 100.0
	# 			)

	# 		_ when (
	# 			growth_time
	# 			< (
	# 				current_plant.plant_details.gestation_time
	# 				+ current_plant.plant_details.growth_time
	# 			)
	# 		):
	# 			if is_fertilized:
	# 				growth_time += delta
	# 			growth_bar.visible = true
	# 			growth_bar.value = (
	# 				(
	# 					(growth_time - current_plant.plant_details.gestation_time)
	# 					/ current_plant.plant_details.growth_time
	# 				)
	# 				* 100.0
	# 			)
	# 			current_plant._on_growing()
	# 		_:
	# 			water_bar.visible = false
	# 			growth_bar.visible = false
	# 			current_plant._on_grown()
	# 			is_grown = true
	# 			particle_emitter.emitting = true
	# 			emit_signal("plant_grown", self)
	# #endregion deprecated state machine processing
#endregion deprecated state machine processing



func _get_details() -> PlantDetails:
	return current_plant.plant_details


func _on_input_event(_viewport, event, _shape_idx) -> void:
	if (
		event is InputEventMouseButton
		and event.pressed
		and event.button_index == MouseButton.MOUSE_BUTTON_LEFT
	):
		print_rich("Plot [color=#0000ff]" + str(plot_id) + "[/color] clicked")
		plot_clicked.emit(self)

		#~~TODO~~: Signal to Game Manager that this plot has been clicked.
		# The Game Manager will then determine what to do based on the
		# CURRENT state of the plot and Little Green's current action queue


func plant(_plant_type: PlantDetails.PlantType) -> void:
	growth_time = 0.0
	is_planted = true
	is_grown = false
	current_plant.plant()
	plant_planted.emit(_plant_type)


func harvest() -> void:
	particle_emitter.emitting = false
	is_planted = false
	is_watered = false
	is_fertilized = false
	is_grown = false
	plant_harvested.emit(current_plant.plant_details)
	current_plant.harvest()


func fertilize() -> void:
	## bit [lb][code]0[/code][rb] [code]0b000X[/code]: Flip Horizontal [br]
	## bit [lb][code]1[/code][rb] [code]0b00X0[/code]: Flip Vertical [br]
	## bit [lb][code]2[/code][rb] [code]0b0X00[/code]: Rotate 90 degrees cw [br]
	## bit [lb][code]3[/code][rb] [code]0bX000[/code]: Rotate 180 degrees ccw
	var transform_bitmask = randi_range(0, 15)
	if (transform_bitmask >> 0) % 2:
		fertilizer_layer.flip_h = true
	if (transform_bitmask >> 1) % 2:
		fertilizer_layer.flip_v = true
	if (transform_bitmask >> 2) % 2:
		fertilizer_layer.rotation_degrees = 90
	if (transform_bitmask >> 3) % 2:
		fertilizer_layer.rotation_degrees = -180
	fertilizing_timer.wait_time = 1.0 - Parameters.little_green_fertilizing_speed_multiplier
	fertilizer_anim.visible = true
	fertilizer_anim.speed_scale = 1 / fertilizing_timer.wait_time
	fertilizer_anim.play("default")
	fertilizing_timer.start()


func water() -> void:
	watering_timer.wait_time = 1.0 - Parameters.little_green_watering_speed_multiplier
	water_anim.visible = true
	water_anim.speed_scale = 1 / watering_timer.wait_time
	water_anim.play("default")
	watering_timer.start()
