class_name LittleGreen
extends CharacterBody2D

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
	idle_state.set_enter(func() -> void: pass)
	idle_state.set_process(func(_delta: float) -> void: pass)
	idle_state.set_exit(func() -> void: pass)

	var traveling_state: StateMachine.State = StateMachine.State.new()
	traveling_state.set_enter(func() -> void: pass)
	traveling_state.set_process(func(_delta: float) -> void: pass)
	traveling_state.set_exit(func() -> void: pass)

	var planting_state: StateMachine.State = StateMachine.State.new()
	planting_state.set_enter(func() -> void: pass)
	planting_state.set_process(func(_delta: float) -> void: pass)
	planting_state.set_exit(func() -> void: pass)

	var harvesting_state: StateMachine.State = StateMachine.State.new()
	harvesting_state.set_enter(func() -> void: pass)
	harvesting_state.set_process(func(_delta: float) -> void: pass)
	harvesting_state.set_exit(func() -> void: pass)

	var unloading_state: StateMachine.State = StateMachine.State.new()
	unloading_state.set_enter(func() -> void: pass)
	unloading_state.set_process(func(_delta: float) -> void: pass)
	unloading_state.set_exit(func() -> void: pass)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	state_machine._process(_delta)

func _on_plant_grown(plot_id: int) -> void:
	harvest_queue.push(plot_id)

func _on_plant_harvested(plot_id: int) -> void:
	plant_queue.push(plot_id)