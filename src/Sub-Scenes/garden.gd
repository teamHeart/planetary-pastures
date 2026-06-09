class_name Garden
extends TileMapLayer

signal return_plot_details(details: Dictionary)



func _ready() -> void:
	get_tree().get_first_node_in_group("LittleGreen").connect(
		"request_plot_details", Callable(self, "_on_request_plot_details")
	)
	name="Garden"


func _on_request_plot_details(plot_id: int) -> void:
	var plot_node: GardenPlot = find_child(("Plot_" + str(plot_id)), true, false)
	if plot_node != null:
		return_plot_details.emit(plot_node._get_details())
