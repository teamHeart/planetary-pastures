class_name ActionQueue
extends Action

# Add any common properties or methods for action type here
var queue: Queue = Queue.new()
var current_action: Action = null


func _init(_object: Node, _args: Array[Action] = []) -> void:
	super._init(_object)
	# Initialize any additional properties or perform setup based on the provided arguments
	if _args.size() > 0:
		queue._items = _args.duplicate()


func execute(_delta: float) -> void:
	if current_action == null and queue.is_empty():
		action_completed.emit()
		return
	if current_action == null:
		current_action = queue.pop()
	current_action.execute(_delta)
	# Implement the logic to execute the action based on its type and arguments


# logic for chain-adding actions to the queue
func add(_action: Action) -> ActionQueue:
	queue.push(_action)
	_action.connect("action_completed", func() -> void: current_action = null)
	return self

#~ TODO: connect completions signals as added
#~ TODO: yes yes
