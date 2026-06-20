extends MarginContainer

var menu_open: bool = false

@onready var menu = %Menu
@onready var container = %Container


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu.connect("pressed", Callable(self, "_on_menu_pressed"))
	container.add_theme_constant_override("separation", -44)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_menu_pressed() -> void:
	print("Menu button pressed")
	var tween = get_tree().create_tween().bind_node(self)
	(
		tween
		. tween_method(
			Callable(self, "adjust_separation"),
			4 if menu_open else -44,
			-44 if menu_open else 4,
			0.25
		)
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_OUT)
	)
	menu_open = not menu_open


func adjust_separation(_sep: int) -> void:
	container.add_theme_constant_override("separation", _sep)
