class_name LittleGreen
extends CharacterBody2D

var target_position: Vector2 = Vector2.ZERO
var current_plot_id: int = -1

## Elements in plants_holding Queue are dictionaries with the following structure:[br]
## {
##    [i][b]"plant_type"[/b][/i]: [code]PlantType[/code],
##    [i][b]"count"[/b][/i]: [code]int[/code]
## }
var plants_holding: Queue = Queue.new()

@onready var plant_queue: Queue = Queue.new()
@onready var harvest_queue: Queue = Queue.new()
@onready var state_machine: StateMachine = StateMachine.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("plant_grown", Callable(self, "_on_plant_grown"))
	connect("plant_harvested", Callable(self, "_on_plant_harvested"))

	# Set up State Machine
	state_machine.set_operator(self)

	# Set up states

	var idle_state: StateMachine.State = StateMachine.State.new()
	var traveling_state: StateMachine.State = StateMachine.State.new()
	var planting_state: StateMachine.State = StateMachine.State.new()
	var harvesting_state: StateMachine.State = StateMachine.State.new()
	var unloading_state: StateMachine.State = StateMachine.State.new()


	# Idle State
	idle_state.set_enter(func() -> void: pass)
	idle_state.set_process(func(_delta: float) -> void:
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


	# Traveling State
	traveling_state.set_enter(func() -> void: pass)
	traveling_state.set_process(func(_delta: float) -> void: pass)
	traveling_state.set_exit(func() -> void: pass)


	# Planting State
	planting_state.set_enter(func() -> void: pass)
	planting_state.set_process(func(_delta: float) -> void: pass)
	planting_state.set_exit(func() -> void: pass)


	# Harvesting State
	harvesting_state.set_enter(func() -> void: pass)
	harvesting_state.set_process(func(_delta: float) -> void: pass)
	harvesting_state.set_exit(func() -> void: pass)


	# Unloading State
	unloading_state.set_enter(func() -> void: pass)
	unloading_state.set_process(func(_delta: float) -> void: pass)
	unloading_state.set_exit(func() -> void: pass)

	state_machine.change_state(idle_state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	state_machine._process(_delta)

func _on_plant_grown(plot_id: int) -> void:
	harvest_queue.push(plot_id)

func _on_plant_harvested(plot_id: int) -> void:
	plant_queue.push(plot_id)

func num_plants_holding() -> int:
	var count: int = 0
	var temp_queue : Array = plants_holding.peek_all()
	for i in range(temp_queue.size()):
		count += temp_queue[i]["count"]
	return count