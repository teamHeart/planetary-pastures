class_name Garden
extends TileMapLayer

signal return_plot_details(details: Dictionary)


func _ready() -> void:
	get_tree().get_first_node_in_group("LittleGreen").connect(
		"request_plot_details", Callable(self, "_on_request_plot_details")
	)
	name = "Garden"


func _on_request_plot_details(plot_id: int) -> void:
	print_rich(
		"Received request for plot details with plot_id: [color=green]" + str(plot_id) + "[/color]"
	)
	var plot_node: GardenPlot = get_children()[get_children().find(
		func(node: GardenPlot) -> bool: return node is GardenPlot and node.plot_id == plot_id
	)]
	# find_child(("Plot_" + str(plot_id)), true, false)
	print_rich(
		"Found plot node: [color=green]"
		+ str(plot_node)
		+ "[/color] for plot_id: [color=green]"
		+ str(plot_id)
		+ "[/color]"
	)
	if plot_node != null:
		return_plot_details.emit(plot_node._get_details())
