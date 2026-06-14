extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	seed(Time.get_ticks_usec())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed_by_event("QUIT", event):
		get_viewport().set_input_as_handled()
		get_tree().quit()
