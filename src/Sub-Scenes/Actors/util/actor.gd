class_name Actor
extends CharacterBody2D

## This class represents an actor in the game.
## It uses a state machine to manage its behavior and an action queue to manage its actions.

## The state machine allows the actor to switch between different states
## (e.g., IDLE, WORKING) and execute specific code for each state.
## The action queue allows the actor to queue up actions that it will perform in order.
var state_machine: StateMachine = StateMachine.new()

## The queue of [param Actions] that the actor will perform
var action_queue: Queue = Queue.new()

#region IDLE state
var idle_enter: Callable = func() -> void:
	# This function is called when the IDLE state is entered.
	# You can add any initialization code for the IDLE state here.
	pass

var idle_process: Callable = func(_delta: float) -> void:
	# This function is called every frame while the IDLE state is active.
	# You can add any code that should run continuously in the IDLE state here.
	pass
var idle_exit: Callable = func() -> void:
	# This function is called when the IDLE state is exited.
	# You can add any cleanup code for the IDLE state here.
	pass
#endregion IDLE state

#region WORKING state
var working_enter: Callable = func() -> void:
	# This function is called when the WORKING state is entered.
	# You can add any initialization code for the WORKING state here.
	pass

var working_process: Callable = func(_delta: float) -> void:
	# This function is called every frame while the WORKING state is active.
	# You can add any code that should run continuously in the WORKING state here.
	pass

var working_exit: Callable = func() -> void:
	# This function is called when the WORKING state is exited.
	# You can add any cleanup code for the WORKING state here.
	pass
#endregion WORKING state


func _ready() -> void:
	# set self as the operator of the state machine
	state_machine.set_operator(self)

	#set up the IDLE state
	var idle_state: StateMachine.State = StateMachine.State.new()
	idle_state.set_enter(idle_enter)
	idle_state.set_process(idle_process)
	idle_state.set_exit(idle_exit)
	state_machine.add_state("IDLE", idle_state)

	var working_state: StateMachine.State = StateMachine.State.new()
	working_state.set_enter(working_enter)
	working_state.set_process(working_process)
	working_state.set_exit(working_exit)
	state_machine.add_state("WORKING", working_state)


func _process(_delta: float) -> void:
	var dots: Array = [
		velocity.normalized().dot(Vector2(1, -1).normalized()),
		velocity.normalized().dot(Vector2(-1, -1).normalized())
	]
	match dots:
		_ when dots[0] >= 0 and dots[1] >= 0:
			# moving north
			pass
		_ when dots[0] >= 0 and dots[1] <= 0:
			# east
			pass
		_ when dots[0] <= 0 and dots[1] >= 0:
			# west
			pass
		_ when dots[0] <= 0 and dots[1] <= 0:
			# south
			pass
