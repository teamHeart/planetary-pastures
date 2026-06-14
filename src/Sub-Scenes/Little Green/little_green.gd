class_name LittleGreen
extends CharacterBody2D

@warning_ignore_start("unused_signal")
@warning_ignore_start("unused_private_class_variable")

signal request_plot_details(plot_id: int)
signal planted_on_plot(plot_id: int)
signal harvested_from_plot(plot_id: int)


## Elements in plants_holding Queue are dictionaries with the following structure:[br]
## {
##    [i][b]"plant_type"[/b][/i]: [code]PlantType[/code],
##    [i][b]"count"[/b][/i]: [code]int[/code]
## }
var plants_holding: Queue = Queue.new()

var plant_queue: Queue = Queue.new()
var harvest_queue: Queue = Queue.new()
var state_machine: StateMachine = StateMachine.new()

var _target_plot_id: int = -1

var _is_traveling: bool = false
var _processing_timer: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("connect_to_plots")
	## Sets Little Green's target location to the plot with plot_id from the request
	get_tree().get_root().find_child("Garden", true, false).call_deferred(
		"connect", "return_plot_details", func(_details: PlantDetails) -> void: pass
	)

	# Set up State Machine
	state_machine.set_operator(self)

	# Set up states

	var idle_state: StateMachine.State = StateMachine.State.new()
	var planting_state: StateMachine.State = StateMachine.State.new()
	var harvesting_state: StateMachine.State = StateMachine.State.new()
	var unloading_state: StateMachine.State = StateMachine.State.new()

	#region Idle State
	idle_state.set_enter(func() -> void: pass)
	idle_state.set_process(
		func(_delta: float) -> void:
			if num_plants_holding() >= Parameters.get_little_green_carry_capacity():
				state_machine.change_state(unloading_state)
			elif not harvest_queue.is_empty():
				state_machine.change_state(harvesting_state)
			elif not plant_queue.is_empty():
				state_machine.change_state(planting_state)
			else:
				# Idle behavior (i.e., do nothing or play idle animation)
				pass
	)
	idle_state.set_exit(func() -> void: pass)
	#endregion Idle State


	#region Planting State
	planting_state.set_enter(func() -> void: pass)
	planting_state.set_process(func(_delta: float) -> void: pass)
	planting_state.set_exit(func() -> void: pass)
	#endregion Planting State


	#region Harvesting State
	harvesting_state.set_enter(func() -> void: pass)
	harvesting_state.set_process(func(_delta: float) -> void: pass)
	harvesting_state.set_exit(func() -> void: pass)
	#endregion


	#region Unloading State
	unloading_state.set_enter(func() -> void: pass)
	unloading_state.set_process(func(_delta: float) -> void: pass)
	unloading_state.set_exit(func() -> void: pass)
	#endregion

	state_machine.change_state(idle_state)


func connect_to_plots() -> void:
	for plot in get_tree().get_root().find_child("Garden", true, false).get_children():
		plot.connect("plant_grown", Callable(self, "_on_plant_grown"))
		plot.connect("plant_harvested", Callable(self, "_on_plant_harvested"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	state_machine._process(_delta)


func _on_plant_grown(plot_id: int) -> void:
	print_rich(
		(
			"Received signal that plant has grown on plot with plot_id: [color=green]"
			+ str(plot_id)
			+ "[/color]"
		)
	)
	harvest_queue.push(plot_id)


func _on_plant_harvested(plot_id: int) -> void:
	plant_queue.push(plot_id)


func num_plants_holding() -> int:
	var count: int = 0
	var temp_queue: Array = plants_holding.peek_all()
	for i in range(temp_queue.size()):
		count += temp_queue[i]["count"]
	return count
