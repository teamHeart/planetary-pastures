extends Control

signal tool_selected(tool: Tool.Type)
signal request_tool_qty(tool: Tool.Type)

var current_tool: Tool = Tool.none()
var last_seed_tool: Tool = null
var tool_quantity: int = 0
var current_wattage: int = 0

#region Preload Tools

#region Nonvolatile Tools
@onready var none_tool: Tool = Tool.none()
@onready var pickaxe_tool: Tool = preload("uid://b7558iox0hnwy")
@onready var watering_can_tool: Tool = preload("uid://dbdkwxyutet")
@onready var fertilizer_tool: Tool = preload("uid://btj2wku5p6m8d")
@onready var seeds_tool: Tool
#endregion Nonvolatile Tools

#region Seed Tools
@onready var pulsar_puff_seeds_tool: Tool = preload("uid://bs2d5svqwskvw")
@onready var rocarrot_seeds_tool: Tool
@onready var saturose_seeds_tool: Tool
@onready var white_dwarf_dropflower_seeds_tool: Tool
@onready var moon_orchid_seeds_tool: Tool
@onready var nursery_melon_seeds_tool: Tool
@onready var stellar_cabbage_seeds_tool: Tool
@onready var moonberry_bush_seeds_tool: Tool
@onready var star_cluster_seeds_tool: Tool
@onready var basket_stinkhorn_seeds_tool: Tool
@onready var gas_giant_gourd_seeds_tool: Tool
@onready var heart_of_the_stars_seeds_tool: Tool = preload("uid://bs18u41brgksm")
#endregion Seed Tools
#endregion Preload Tools

@onready var current_item: TextureRect = %CurrentItem
@onready var tool_label: RichTextLabel = %ToolLabel
@onready var tool_qty: RichTextLabel = %ToolQty
@onready var watt_counter = %WattCounter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		print_rich(
			(
				"Key pressed: [color=green]"
				+ OS.get_keycode_string(event.keycode)
				+ "[/color]: [color=red]"
				+ str(event.keycode)
				+ "[/color]"
			)
		)
		var key: int = -1
		var requested_tool: Tool = null
		match event.keycode:
			KEY_DELETE:
				key = 0  # None
				requested_tool = none_tool
			KEY_Q:
				key = 1  # Pickaxe
				requested_tool = pickaxe_tool
			KEY_E:
				key = 2  # Watering Can
				requested_tool = watering_can_tool
			KEY_F:
				key = 3  # Fertilizer
				requested_tool = fertilizer_tool
			KEY_R:
				key = 4  # Seeds
				requested_tool = (
					last_seed_tool if last_seed_tool != null else heart_of_the_stars_seeds_tool
				)
			KEY_1:
				key = 5  # Pulsar Puff Seeds
				requested_tool = pulsar_puff_seeds_tool
			KEY_2:
				key = 6  # Rocarrot Seeds
				requested_tool = rocarrot_seeds_tool
			KEY_3:
				key = 7  # Saturose Seeds
				requested_tool = saturose_seeds_tool
			KEY_4:
				key = 8  # White Dwarf Dropflower Seeds
				requested_tool = white_dwarf_dropflower_seeds_tool
			KEY_5:
				key = 9  # Moon Orchid Seeds
				requested_tool = moon_orchid_seeds_tool
			KEY_6:
				key = 10  # Nursery Melon Seeds
				requested_tool = nursery_melon_seeds_tool
			KEY_7:
				key = 11  # Stellar Cabbage Seeds
				requested_tool = stellar_cabbage_seeds_tool
			KEY_8:
				key = 12  # Moonberry Bush Seeds
				requested_tool = moonberry_bush_seeds_tool
			KEY_9:
				key = 13  # Star Cluster Seeds
				requested_tool = star_cluster_seeds_tool
			KEY_0:
				key = 14  # Basket Stinkhorn Seeds
				requested_tool = basket_stinkhorn_seeds_tool
			KEY_MINUS:
				key = 15  # Gas Giant Gourd Seeds
				requested_tool = gas_giant_gourd_seeds_tool
			KEY_EQUAL:
				key = 16  # Heart of the Stars Seeds
				requested_tool = heart_of_the_stars_seeds_tool
			_:
				key = -1  # Unrecognized key
		if key >= 4:
			last_seed_tool = requested_tool
		if key != -1 and key <= Tool.current_unlock_level:
			if current_tool:
				current_tool = requested_tool
				current_item.texture = current_tool.icon
				tool_label.text = current_tool.name
				emit_signal("tool_selected", current_tool.type)
				emit_signal("request_tool_qty", current_tool.type)


func update_tool_quantity(quantity: int) -> void:
	if current_tool == null:
		tool_qty.text = ""
		return
	if not current_tool.countable:
		tool_qty.text = ""
	else:
		tool_quantity = quantity
		tool_qty.text = str(tool_quantity)


func add_watts(amount: int) -> void:
	current_wattage += amount
	watt_counter.text = (
		"[tornado radius="
		+ str(max(min(3, log(log(current_wattage as float) / log(10.0))), 0))
		+ " freq="
		+ str(max(min(20, log(current_wattage as float) / log(10.0)), 0))
		+ "]"
		+ str(current_wattage)
		+ " W[/tornado]"
	)  #  + "]str(current_wattage)
