class_name LittleGreen
extends Actor

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

var current_tool: Tool = Tool.none()
var plants_holding: Queue = Queue.new()

var plant_queue: Queue = Queue.new()
var harvest_queue: Queue = Queue.new()
var harvest_queue_lock: bool = false

var _target_plot_id: int = -1

var _is_traveling: bool = false
var _processing_timer: float = 0.0

var _action_queue: Queue = Queue.new()
var _current_action: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO Refactor this to be cleaner and more modular.
	# ? Maybe have a separate function for setting up the state machine and its states?
	pass
	# XXX Delete all this below

	# 	call_deferred("connect_to_plots")
	# 	## Sets Little Green's target location to the plot with plot_id from the request
	# 	get_tree().get_root().find_child("Garden", true, false).call_deferred(
	# 		"connect", "return_plot_details", func(_details: PlantDetails) -> void: pass
	# 	)

	# 	# Set up State Machine
	# 	state_machine.set_operator(self)

	# 	# Set up states

	# 	var idle_state: StateMachine.State = StateMachine.State.new()
	# 	var planting_state: StateMachine.State = StateMachine.State.new()
	# 	var harvesting_state: StateMachine.State = StateMachine.State.new()
	# 	var unloading_state: StateMachine.State = StateMachine.State.new()

	# 	#region Idle State
	# 	idle_state.set_enter(func() -> void: pass)
	# 	idle_state.set_process(
	# 		func(_delta: float) -> void:
	# 			if num_plants_holding() >= Parameters.get_little_green_carry_capacity():
	# 				state_machine.change_state(unloading_state)
	# 			elif not harvest_queue.is_empty():
	# 				state_machine.change_state(harvesting_state)
	# 			elif not plant_queue.is_empty():
	# 				state_machine.change_state(planting_state)
	# 			else:
	# 				# Idle behavior (i.e., do nothing or play idle animation)
	# 				pass
	# 	)
	# 	idle_state.set_exit(func() -> void: pass)
	# 	#endregion Idle State

	# 	#region Planting State
	# 	planting_state.set_enter(func() -> void: pass)
	# 	planting_state.set_process(func(_delta: float) -> void: pass)
	# 	planting_state.set_exit(func() -> void: pass)
	# 	#endregion Planting State

	# 	#region Harvesting State
	# 	harvesting_state.set_enter(func() -> void: pass)
	# 	harvesting_state.set_process(func(_delta: float) -> void: pass)
	# 	harvesting_state.set_exit(func() -> void: pass)
	# 	#endregion

	# 	#region Unloading State
	# 	unloading_state.set_enter(func() -> void: pass)
	# 	unloading_state.set_process(func(_delta: float) -> void: pass)
	# 	unloading_state.set_exit(func() -> void: pass)
	# 	#endregion

	# 	state_machine.change_state(idle_state)


#~ HACK: can prob remove this now that Game Manager is handling comms
# func connect_to_plots() -> void:
# 	for plot in get_tree().get_root().find_child("Garden", true, false).get_children():
# 		plot.connect("plant_grown", Callable(self, "_on_plant_grown"))
# 		plot.connect("plant_harvested", Callable(self, "_on_plant_harvested"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	super._process(_delta)
	# NOTE that this is a temporary implementation of the state machine and action queue processing.
	# state_machine._process(_delta)
# HACK: refactor to use new Action types
#? Do I want harvests to be processed immediately or in turn?
#? i.e. should I insert them at the front or the back of the queue

	if _current_action == {}:
		if !harvest_queue.is_empty() and !harvest_queue_lock:
			var active_plot: GardenPlot = harvest_queue.pop()
			_action_queue.push_front({"type": "harvest_queue_unlock"})
			(
				_action_queue
				. push_front(
					{
						"type": "process_plot",
						"plot": active_plot,
					}
				)
			)
			(
				_action_queue
				. push_front(
					{
						"type": "move_to_plot",
						"target_position": active_plot.global_position,
					}
				)
			)
			_action_queue.push_front({"type": "harvest_queue_lock"})
		elif !_action_queue.is_empty():
			_current_action = _action_queue.pop()
			print("Processing action: ", _current_action)
	process_current_action(_delta)


func _on_plant_harvested(plot_id: int) -> void:
	plant_queue.push(plot_id)


func num_plants_holding() -> int:
	var count: int = 0
	var temp_queue: Array = plants_holding.peek_all()
	for i in range(temp_queue.size()):
		count += temp_queue[i]["count"]
	return count


#TODO: make an abstract Action class
#TODO: add a size limit to the action queue
func add_action_to_queue(action: Dictionary) -> void:
	_action_queue.push(action)


func process_current_action(_delta: float) -> void:
	if _current_action == {}:
		return
	match _current_action["type"]:
		"harvest_queue_lock":
			harvest_queue_lock = true
			_current_action = {}
		"harvest_queue_unlock":
			harvest_queue_lock = false
			_current_action = {}
		"move_to_plot":
			move_action(_current_action["target_position"])
		"process_plot":
			_processing_timer += _delta
			var active_plot: GardenPlot = _current_action["plot"]

			if !active_plot.is_planted:
				plant_on_plot(active_plot, _delta)
			if active_plot.is_grown:
				harvest_from_plot(active_plot, _delta)

			# if _processing_timer >= active_plot.current_plant.plant_details.plant_time:
			# 	active_plot.plant( _current_action["plant_type"] )
			# 	_processing_timer = 0.0
			# 	_current_action = {}
			#~ TODO: Implement planting action processing

		"harvest_from_plot":
			#~ TODO: Implement harvesting action processing
			pass
		"water_plot":
			#~ TODO: Implement watering action processing
			water_plot(_current_action["plot"], _delta)
		"fertilize_plot":
			#~ TODO: Implement fertilizing action processing
			fertilize_plot(_current_action["plot"], _delta)
		"unload_plants":
			# TODO: Implement unloading action processing
			pass
		"mine_from_rock":
			# TODO: Implement mining action processing
			pass


func move_action(target_position: Vector2) -> void:
	var direction: Vector2 = position.direction_to(target_position).normalized()
	velocity = direction * Parameters.little_green_move_speed
	if position.distance_to(target_position) < 32.0:
		velocity = Vector2.ZERO
		_current_action = {}
		sprite.play("Idle" + animation_direction)
		return
	move_and_slide()
	sprite.play("Walk" + animation_direction)
	print(sprite.animation)


func plant_on_plot(active_plot: GardenPlot, _delta: float) -> void:
	_processing_timer += _delta
	if _processing_timer >= active_plot.current_plant.plant_details.plant_time:
		active_plot.plant(active_plot.current_plant.plant_type)
		_processing_timer = 0.0
		_current_action = {}


func water_plot(active_plot: GardenPlot, _delta: float) -> void:
	_processing_timer += _delta
	if _processing_timer >= -3.0:
		active_plot.water()
		_processing_timer = 0.0
		_current_action = {}


func fertilize_plot(active_plot: GardenPlot, _delta: float) -> void:
	_processing_timer += _delta
	if _processing_timer >= -3.0:
		active_plot.fertilize()
		_processing_timer = 0.0
		_current_action = {}


func harvest_from_plot(active_plot: GardenPlot, _delta: float) -> void:
	_processing_timer += _delta
	if _processing_timer >= active_plot.current_plant.plant_details.plant_time:
		active_plot.harvest()
		_processing_timer = 0.0
		_current_action = {}
