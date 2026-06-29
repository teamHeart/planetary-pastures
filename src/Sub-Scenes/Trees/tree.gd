@tool
extends Node2D

@export_enum("Tall", "Short") var tree_type: int:
	set(value):
		tree_type = value
		dirty = true
	get:
		return tree_type

var dirty: bool = false

@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dirty:
		sprite.region_rect = Rect2(32*tree_type, 0, 32, 112)
		dirty = false
