class_name MoveAction
extends Action

# Add any common properties or methods for action type here
var destination: Vector2 = Vector2.ZERO
var move_speed: float = 0.0


func _init(_object: Node, _destination: Vector2, _move_speed: float) -> void:
	super._init(_object)
	destination = _destination
	move_speed = _move_speed
	# Initialize any additional properties or perform setup based on the provided arguments


func execute(delta: float) -> void:

	var direction: Vector2 = object.position.direction_to(destination)
	var vel: Vector2 = Vector2.ZERO
	var distance: float = object.position.distance_to(destination)

	# Move towards the destination at the specified speed, but don't overshoot

	if distance >= move_speed * delta:
		vel = direction * move_speed
	else:
		vel = direction * distance
	object.velocity = vel

	# Check if we've reached the destination (or are very close to it)

	if distance < 0.05:
		object.position = destination
		object.velocity = Vector2.ZERO
		emit_signal("action_completed", self)
		return

	# Move the object using its velocity

	object.move_and_slide()
