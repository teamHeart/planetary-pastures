class_name LittleGreen
extends CharacterBody2D

signal request_plot_details(plot_id: int)
signal planted_on_plot(plot_id: int)
signal harvested_from_plot(plot_id: int)

## Elements in plants_holding Queue are dictionaries with the following structure:[br]
## {
##    [i][b]"plant_type"[/b][/i]: [code]PlantType[/code],
##    [i][b]"count"[plant_harvested/b][/i]: [code]int[/code]
## }
var plants_holding: Queue = Queue.new()

var plant_queue: Queue = Queue.new()
var harvest_queue: Queue = Queue.new()
var state_machine: StateMachine = StateMachine.new()

var _target_plot_id: int = -1
var _target_plot_details: Dictionary = {}
var _target_plot_position: Vector2 = Vector2.ZERO
var _target_plot_plant_type: GardenPlot.PlantType = GardenPlot.PlantType.NONE
var _target_plot_yield: int = 0
var _target_plot_plant_time: float = 0.0
var _target_plot_harvest_time: float = 0.0

var _is_traveling: bool = false
var _processing_timer: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("connect_to_plots")
	## Sets Little Green's target location to the plot with plot_id from the request
	get_tree().get_root().find_child("Garden", true, false).call_deferred(
		"connect",
		"return_plot_details",
		func(_details: Dictionary) -> void:
			_target_plot_details = _details
			_target_plot_position = _details.get("location", Vector2.ZERO)
			_target_plot_plant_type = _details.get("plant_type", GardenPlot.PlantType.NONE)
			_target_plot_yield = _details.get("yield", 0)
			_target_plot_plant_time = _details.get("plant_time", 0.0)
			_target_plot_harvest_time = _details.get("harvest_time", 0.0)
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

	#region Plantingplant_harvested State
	planting_state.set_enter(
		func() -> void:
			_target_plot_id = plant_queue.pop()
			_is_traveling = true
			emit_signal("request_plot_details", _target_plot_id)
	)
	planting_state.set_process(
		func(_delta: float) -> void:
			match position.distance_to(_target_plot_position):
				_ when position.distance_to(_target_plot_position) > 5.0:
					var direction: Vector2 = (_target_plot_position - position).normalized()
					velocity = direction * Parameters.get_little_green_move_speed()
					move_and_slide()

				_:
					if _is_traveling:
						_is_traveling = false
					if (
						_processing_timer
						>= (
							_target_plot_plant_time
							/ Parameters.get_little_green_planting_speed_multiplier()
						)
					):
						emit_signal("planted_on_plot", _target_plot_id)
					_processing_timer += (
						_delta * Parameters.get_little_green_planting_speed_multiplier()
					)
	)
	planting_state.set_exit(func() -> void: pass)
	#endregion Planting State

	#region Harvesting State
	harvesting_state.set_enter(
		func() -> void:
			_target_plot_id = harvest_queue.pop()
			_is_traveling = true
			_processing_timer = 0.0
			emit_signal("request_plot_details", _target_plot_id)
	)
	harvesting_state.set_process(
		func(_delta: float) -> void:
			match position.distance_to(_target_plot_position):
				_ when position.distance_to(_target_plot_position) > 5.0:
					var direction: Vector2 = (_target_plot_position - position).normalized()
					velocity = direction * Parameters.get_little_green_move_speed()
					move_and_slide()

				_:
					if _is_traveling:
						_is_traveling = false
					if (
						_processing_timer
						>= (
							_target_plot_harvest_time
							/ Parameters.get_little_green_harvesting_speed_multiplier()
						)
					):
						if (
							_target_plot_plant_type != GardenPlot.PlantType.NONE
							and _target_plot_yield > 0
						):
							plants_holding.push(
								{"plant_type": _target_plot_plant_type, "count": _target_plot_yield}
							)
						state_machine.change_state(idle_state)
					_processing_timer += (
						_delta * Parameters.get_little_green_harvesting_speed_multiplier()
					)
	)
	harvesting_state.set_exit(func() -> void: emit_signal("harvested_from_plot", _target_plot_id))
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
