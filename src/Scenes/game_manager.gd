extends Node

var inventory: Dictionary[Tool.Type, int] = {}
var current_tool: Tool.Type = Tool.Type.NONE
var last_seed_tool: Tool.Type = Tool.Type.PULSAR_PUFF_SEEDS

@onready var game_scene: Node2D = $GameScene
@onready var ui_layer: Control = %UILayer
@onready var garden: TileMapLayer = %Garden
@onready var little_green: Node = %LittleGreen


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
			plot.connect("plot_clicked", Callable(self, "_on_plot_clicked"))
			plot.connect("plant_watered", Callable(self, "_on_plant_watered"))
			plot.connect("plant_fertilized", Callable(self, "_on_plant_fertilized"))


func _on_request_tool_qty(tool: Tool.Type) -> void:
	var quantity = inventory.get(tool, -1)
	if quantity == -1:
		quantity = 10  # Default quantity for testing purposes
		inventory[tool] = quantity
	ui_layer.update_tool_quantity(quantity)


func _on_tool_selected(tool: Tool.Type) -> void:
	print("Tool selected:", Tool.tool_type_to_string(tool))
	if tool > 10:
		GardenPlot.current_tool = tool as PlantDetails.PlantType
	else:
		GardenPlot.current_tool = PlantDetails.PlantType.NONE
	current_tool = tool


func _on_plant_planted(plant_type: PlantDetails.PlantType) -> void:
	if plant_type == PlantDetails.PlantType.NONE:
		return
	print_rich(
		(
			"PlantDetails planted: [color=yellow]"
			+ PlantDetails.plant_type_to_string(plant_type)
			+ "[/color]"
		)
	)
	inventory[plant_type as Tool.Type] -= 1

	# 		pass
	ui_layer.update_tool_quantity(inventory.get(plant_type as Tool.Type, -1))


func _on_plot_clicked(plot: GardenPlot) -> void:
	print("Plot clicked:", plot.plot_id)

	#Move Little Green to the clicked plot
	little_green.add_action_to_queue(
		{"type": "move_to_plot", "target_position": plot.global_position}
	)
	print_rich(
		(
			"Added action to move to plot with id: [color=green]"
			+ str(plot.plot_id)
			+ "[/color] at position: [color=green]"
			+ str(plot.global_position)
			+ "[/color]"
		)
	)
	if plot.is_grown:
		little_green.add_action_to_queue({"type": "process_plot", "plot": plot})
		print_rich(
			(
				"Added action to process plot with id: [color=green]"
				+ str(plot.plot_id)
				+ "[/color] at position: [color=green]"
				+ str(plot.global_position)
				+ "[/color]"
			)
		)
		return

	#plant on this plot if Little Green is holding seeds
	if current_tool > 10 and inventory.get(plot.current_tool as Tool.Type, 0) > 0:
		plot.current_plant.plant_type = current_tool as PlantDetails.PlantType
		print_rich(
			(
				"Plant [color=#00ff00]"
				+ PlantDetails.plant_type_to_string(plot.current_plant.plant_type)
				+ "[/color] planned for plot with id: [color=#0000ff]"
				+ str(plot.plot_id)
				+ "[/color]"
			)
		)
		little_green.add_action_to_queue({"type": "process_plot", "plot": plot})
		print_rich(
			(
				"Added action to plant [color=green]"
				+ PlantDetails.plant_type_to_string(plot.current_tool)
				+ "[/color] on plot with id: [color=green]"
				+ str(plot.plot_id)
				+ "[/color]"
			)
		)

	#water this plot if Little Green is holding the watering can
	elif current_tool == Tool.Type.WATERING_CAN:
		(
			little_green
			. add_action_to_queue(
				{
					"type": "water_plot",
					"plot": plot,
				}
			)
		)
		print_rich(
			"Added action to water plot with id: [color=#0000ff]" + str(plot.plot_id) + "[/color]"
		)

	#fertilize this plot if Little Green is holding the fertilizer
	elif current_tool == Tool.Type.FERTILIZER:
		(
			little_green
			. add_action_to_queue(
				{
					"type": "fertilize_plot",
					"plot": plot,
				}
			)
		)
		print_rich(
			(
				"Added action to fertilize plot with id: [color=#0000ff]"
				+ str(plot.plot_id)
				+ "[/color]"
			)
		)


func _on_plant_grown(plot: GardenPlot) -> void:
	print_rich(
		(
			"Received signal that plant has grown on plot with plot_id: [color=green]"
			+ str(plot.plot_id)
			+ "[/color]"
		)
	)
	little_green.harvest_queue.push(plot)

func _on_plant_harvested(plant: PlantDetails) -> void:
	ui_layer.add_watts(plant.yield_amount)