class_name GardenPlot
extends Node2D

@warning_ignore_start("unused_signal")
signal plant_grown(plot_id: int)
signal plant_harvested(produced: int)


static var plot_counter: int = 0

var growth_percent: float = 0.0

var plot_id: int = 0

@warning_ignore_start("unused_private_class_variable")
var _growth_time: float = 0.0
var _is_grown: bool = false

@onready var flower_sprite: Sprite2D = $Flower
@onready var lump_sprite: Sprite2D = $Lump
@onready var particle_emitter: CPUParticles2D = $Particles
@onready var anim_player: AnimationPlayer = $Flower/AnimationPlayer
@onready var area_2d: Area2D = $Area2D


func _enter_tree() -> void:
	# Ensure the plot_id is unique and correctly assigned
	plot_id = plot_counter
	name = "Plot_" + str(plot_id)
	plot_counter += 1
	add_to_group("GardenPlots", true)
	print_rich(
		(
			"GardenPlot [color=blue]"
			+ name
			+ "[/color] entered tree with plot_id: [color=green]"
			+ str(plot_id)
			+ "[/color]"
		)
	)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_first_node_in_group("LittleGreen").call_deferred(
		"connect", "planted_on_plot", Callable(self, "_on_planted_on_plot")
	)
	get_tree().get_first_node_in_group("LittleGreen").call_deferred(
		"connect", "harvested_from_plot", Callable(self, "_on_harvested_from_plot")
	)

	plant(PlantDetails.PlantType.NONE)  # Initialize the plot with no plant
	# Set the initial scale of the sprites
	lump_sprite.scale = Vector2(1.0, 1.0)
	flower_sprite.scale = Vector2(0.0, 0.0)

	# setup the animation player
	anim_player.stop()
	particle_emitter.emitting = false

	# make clickable
	area_2d.connect("input_event", Callable(self, "_on_input_event"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _get_details() -> Dictionary:
	return {}


func plant(_plant_type: PlantDetails.PlantType) -> void:
	pass


func harvest() -> int:
	return 0


func _on_input_event(_viewport, event, _shape_idx) -> void:
	if (
		event is InputEventMouseButton
		and event.pressed
		and event.button_index == MouseButton.MOUSE_BUTTON_LEFT
	):
		pass

func _on_planted_on_plot(_plot_id: int) -> void:
	# This function can be used to trigger any additional effects when a plant is planted on the plot
	pass


func _on_harvested_from_plot(_plot_id: int) -> void:
	# This function can be used to trigger any additional
	# effects when a plant is harvested from the plot
	harvest()
