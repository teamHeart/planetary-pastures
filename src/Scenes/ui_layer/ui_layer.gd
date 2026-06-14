extends Control

signal tool_selected(tool: String)
signal request_tool_qty(tool: String)

var current_tool: PlantDetails.PlantType = PlantDetails.PlantType.NONE
var tool_text: String = "None"
var tool_quantity: int = 0

@onready var basket_stinkhorn_seeds = preload("uid://dop1311pfpkse")
@onready var gas_giant_gourd_seeds = preload("uid://cgjputfesglkv")
@onready var heart_of_the_stars_seeds = preload("uid://dgoevbnhjlbss")
@onready var moon_orchid_seeds = preload("uid://b2nwgke2d6q7o")
@onready var moonberry_bush_seeds = preload("uid://s4vybvuylemm")

@onready var current_item: TextureRect = %CurrentItem
@onready var tool_label: Label = %ToolLabel
@onready var tool_qty: Label = %ToolQty


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		print_rich("Key pressed: [color=green]" + OS.get_keycode_string(event.keycode) + "[/color]")
		match event.keycode:
			KEY_1:
				current_item.texture = basket_stinkhorn_seeds
				tool_text = "Basket Stinkhorn Seeds"
				tool_label.text = tool_text
				request_tool_qty.emit("Basket Stinkhorn")
				tool_selected.emit("Basket Stinkhorn")
			KEY_2:
				current_item.texture = gas_giant_gourd_seeds
				tool_text = "Gas Giant Gourd Seeds"
				tool_label.text = tool_text
				request_tool_qty.emit("Gas Giant Gourd")
				tool_selected.emit("Gas Giant Gourd")
			KEY_3:
				current_item.texture = heart_of_the_stars_seeds
				tool_text = "Heart of the Stars Seeds"
				tool_label.text = tool_text
				request_tool_qty.emit("Heart of the Stars")
				tool_selected.emit("Heart of the Stars")
			KEY_4:
				current_item.texture = moon_orchid_seeds
				tool_text = "Moon Orchid Seeds"
				tool_label.text = tool_text
				request_tool_qty.emit("Moon Orchid")
				tool_selected.emit("Moon Orchid")
			KEY_5:
				current_item.texture = moonberry_bush_seeds
				tool_text = "Moonberry Bush Seeds"
				tool_label.text = tool_text
				request_tool_qty.emit("Moonberry Bush")
				tool_selected.emit("Moonberry Bush")
			_:
				pass


func update_tool_quantity(quantity: int) -> void:
	if quantity < 0:
		tool_qty.text = ""
		tool_qty.visible = false
	else:
		tool_qty.visible = true
		tool_quantity = quantity
		tool_qty.text = str(tool_quantity)
