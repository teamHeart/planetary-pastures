extends Node

var inventory: Dictionary[String, int] = {
	"Basket Stinkhorn": 100,
	"Gas Giant Gourd": 100,
	"Heart of the Stars": 100,
	"Moon Orchid": 100,
	"Moonberry Bush": 100,
}

@onready var game_scene: Node2D = $GameScene
@onready var ui_layer: Control = %UILayer
@onready var garden: TileMapLayer = %Garden


func _ready() -> void:
	ui_layer.connect("tool_selected", Callable(self, "_on_tool_selected"))
	ui_layer.connect("request_tool_qty", Callable(self, "_on_request_tool_qty"))
	call_deferred("connect_plot_signals")


func connect_plot_signals() -> void:
	for plot in garden.get_children():
		if plot is GardenPlot:
			plot.connect("plant_planted", Callable(self, "_on_plant_planted"))
			plot.connect("plant_harvested", Callable(self, "_on_plant_harvested"))
			plot.connect("plant_grown", Callable(self, "_on_plant_grown"))


func _on_request_tool_qty(tool: String) -> void:
	var quantity = inventory.get(tool, -1)
	ui_layer.update_tool_quantity(quantity)


func _on_tool_selected(tool: String) -> void:
	print("Tool selected:", tool)
	match tool:
		"Basket Stinkhorn":
			GardenPlot.current_tool = PlantDetails.PlantType.BASKET_STINKHORN
		"Gas Giant Gourd":
			GardenPlot.current_tool = PlantDetails.PlantType.GAS_GIANT_GOURD
		"Heart of the Stars":
			GardenPlot.current_tool = PlantDetails.PlantType.HEART_OF_THE_STARS
		"Moon Orchid":
			GardenPlot.current_tool = PlantDetails.PlantType.MOON_ORCHID
		"Moonberry Bush":
			GardenPlot.current_tool = PlantDetails.PlantType.MOONBERRY_BUSH
		_:
			GardenPlot.current_tool = PlantDetails.PlantType.NONE


func _on_plant_planted(plant_type: PlantDetails.PlantType) -> void:
	if plant_type == PlantDetails.PlantType.NONE:
		return
	print_rich(
		"Plant planted: [color=yellow]" + PlantDetails.plant_type_to_string(plant_type) + "[/color]"
	)
	inventory[PlantDetails.plant_type_to_string(plant_type)] -= 1
	
	# 		pass
	ui_layer.update_tool_quantity(inventory.get(PlantDetails.plant_type_to_string(plant_type), -1))
