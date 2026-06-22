extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", func() -> void: get_tree().quit())
