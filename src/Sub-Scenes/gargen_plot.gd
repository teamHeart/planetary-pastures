class_name GardenPlot
extends Node2D

signal plant_grown(plot_id: int)
signal plant_harvested(produced: int)

enum PlantType { NONE, CARROT, TOMATO, LETTUCE }

static var plant_dict: Dictionary = {
	PlantType.NONE:  # A very large number to prevent growth
	{"tex_offset": Vector2(2, 1), "growth_time": 0.0, "gestation_time": 0b1 << 30, "yield": 0},
	PlantType.CARROT:
	{"tex_offset": Vector2(0, 0), "growth_time": 10.0, "gestation_time": 5.0, "yield": 1},
	PlantType.TOMATO:
	{"tex_offset": Vector2(1, 0), "growth_time": 12.0, "gestation_time": 6.0, "yield": 2},
	PlantType.LETTUCE:
	{"tex_offset": Vector2(2, 0), "growth_time": 8.0, "gestation_time": 4.0, "yield": 3}
}

@export var plot_id: int
@export var plant_type: PlantType = PlantType.NONE
@export_range(0.0, 1.0, 0.01) var growth_percent: float = 0.0

var _growth_time: float = 0.0
var _is_grown: bool = false

@onready var flower_sprite: Sprite2D = $Flower
@onready var lump_sprite: Sprite2D = $Lump
@onready var particle_emitter: CPUParticles2D = $Particles
@onready var anim_player: AnimationPlayer = $Flower/AnimationPlayer
@onready var area_2d: Area2D = $Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plant(PlantType.NONE)  # Initialize the plot with no plant
	# Set the initial scale of the sprites
	lump_sprite.scale = Vector2(1.0, 1.0)
	flower_sprite.scale = Vector2(0.0, 0.0)

	# setup the animation player
	anim_player.stop()
	particle_emitter.emitting = false

	# make clickable
	area_2d.connect("input_event", Callable(self, "_on_input_event"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if plant_type == PlantType.NONE:
		return
	_growth_time += delta
	match _growth_time:
		# Gestation phase
		_ when _growth_time < plant_dict[plant_type]["gestation_time"]:
			pass

		# Growth phase
		_ when (
			_growth_time
			< plant_dict[plant_type]["growth_time"] + plant_dict[plant_type]["gestation_time"]
		):
			var growing_time: float = _growth_time - plant_dict[plant_type]["gestation_time"]
			growth_percent = growing_time / plant_dict[plant_type]["growth_time"]
			lump_sprite.scale = Vector2(1.0, 1.0) * (1.0 - growth_percent)
			flower_sprite.scale = Vector2(1.0, 1.0) * growth_percent

		# Harvest phase
		_:
			if not _is_grown:
				growth_percent = 1.0
				lump_sprite.scale = Vector2(0.0, 0.0)
				flower_sprite.scale = Vector2(1.0, 1.0)
				emit_signal("plant_grown", plot_id)
				_is_grown = true
				anim_player.play("Sway")
				particle_emitter.emitting = true


func plant(_plant_type: PlantType) -> void:
	flower_sprite.scale = Vector2(0.0, 0.0)
	lump_sprite.scale = Vector2(1.0, 1.0)
	self.plant_type = _plant_type
	lump_sprite.visible = true if _plant_type != PlantType.NONE else false
	flower_sprite.region_rect.position = plant_dict[_plant_type]["tex_offset"] * 32.0
	_growth_time = 0.0
	_is_grown = false
	particle_emitter.emitting = false


func harvest() -> int:
	if not _is_grown:
		return 0
	var produced: int = plant_dict[plant_type]["yield"]
	plant(PlantType.NONE)
	emit_signal("plant_harvested", produced)
	return produced


func _on_input_event(_viewport, event, _shape_idx) -> void:
	if (
		event is InputEventMouseButton
		and event.pressed
		and event.button_index == MouseButton.MOUSE_BUTTON_LEFT
	):
		if _is_grown:
			harvest()
		elif plant_type == PlantType.NONE:
			var rand: int = (randi() % 3) + 1  # Randomly select a plant type (excluding NONE)
			plant(PlantType.values()[rand])
