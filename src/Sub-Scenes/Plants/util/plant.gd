@tool
class_name Plant
extends Node2D

const NONE = preload("uid://80xiobujoo3g")
const PULSAR_PUFF = preload("uid://beie48irrsv5q")
const ROCARROT = preload("uid://blrr3ltpvfmqw")
const SATUROSE = preload("uid://bnd6r7nmwnsqu")
const WHITE_DWARF_DROPFLOWER = preload("uid://cxe1cp7br84i")
const MOON_ORCHID = preload("uid://dpfcujmlgqwko")
const NURSERY_MELON = preload("uid://1db0m70xfspo")
const STELLAR_CABBAGE = preload("uid://cpsemdhv3jh4u")
const MOONBERRY_BUSH = preload("uid://cm0ddh4blgue2")
const STAR_CLUSTER = preload("uid://1b7x1hmql4y2")
const BASKET_STINKHORN = preload("uid://baypo8y6hraqw")
const GAS_GIANT_GOURD = preload("uid://dmxqmgm0688e1")
const HEART_OF_THE_STARS = preload("uid://2pqk1leqyb2u")

@export var plant_type: PlantDetails.PlantType:
	get:
		return _plant_type
	set(value):
		_plant_type = value
		match _plant_type:
			PlantDetails.PlantType.NONE:
				_plant_details = NONE
			PlantDetails.PlantType.PULSAR_PUFF:
				_plant_details = PULSAR_PUFF
			PlantDetails.PlantType.ROCARROT:
				_plant_details = ROCARROT
			PlantDetails.PlantType.SATUROSE:
				_plant_details = SATUROSE
			PlantDetails.PlantType.WHITE_DWARF_DROPFLOWER:
				_plant_details = WHITE_DWARF_DROPFLOWER
			PlantDetails.PlantType.MOON_ORCHID:
				_plant_details = MOON_ORCHID
			PlantDetails.PlantType.NURSERY_MELON:
				_plant_details = NURSERY_MELON
			PlantDetails.PlantType.STELLAR_CABBAGE:
				_plant_details = STELLAR_CABBAGE
			PlantDetails.PlantType.MOONBERRY_BUSH:
				_plant_details = MOONBERRY_BUSH
			PlantDetails.PlantType.STAR_CLUSTER:
				_plant_details = STAR_CLUSTER
			PlantDetails.PlantType.BASKET_STINKHORN:
				_plant_details = BASKET_STINKHORN
			PlantDetails.PlantType.GAS_GIANT_GOURD:
				_plant_details = GAS_GIANT_GOURD
			PlantDetails.PlantType.HEART_OF_THE_STARS:
				_plant_details = HEART_OF_THE_STARS
		_dirty = true

var plant_details: PlantDetails:
	get:
		return _plant_details

var _dirty: bool = false
var _plant_details: PlantDetails = NONE
var _plant_type: PlantDetails.PlantType = plant_type

@onready var growing_sprite: Sprite2D = $Growing
@onready var grown_sprite: AnimatedSprite2D = $FullGrown
@onready var sway: AnimationPlayer = $Sway

func plant()->void:
	_on_planted()

func harvest()->void:
	_on_harvested()

func _process(_delta: float) -> void:
	if _dirty:
		growing_sprite.texture = _plant_details.growth_texture
		grown_sprite.frames = _plant_details.grown_animation
		_dirty = false


func _on_planted() -> void:
	growing_sprite.visible = true
	grown_sprite.visible = false
	sway.stop()

	growing_sprite.frame = 0


func _on_growing() -> void:
	growing_sprite.visible = true
	grown_sprite.visible = false
	sway.stop()

	growing_sprite.frame = 1


func _on_grown() -> void:
	if plant_details.grown_animation != null:
		growing_sprite.visible = false
		grown_sprite.visible = true
		grown_sprite.play("default")
	else:
		growing_sprite.visible = true
		grown_sprite.visible = false
		growing_sprite.frame = 2
	sway.play("Sway")


func _on_harvested() -> void:
	plant_type = PlantDetails.PlantType.NONE
	growing_sprite.visible = false
	grown_sprite.visible = false
	sway.play("RESET")


func tool() -> Tool.Type:
	if plant_type >= PlantDetails.PlantType.PULSAR_PUFF:
		return plant_type as Tool.Type
	print_rich("Plant [color=yellow]" + name + "[/color] somehow isn't a plant?")
	return Tool.Type.SEEDS
