class_name Tool
extends Resource

enum Type {
	## No tool selected [br]
	## shortcut key: [lb][code]DELETE[/code][rb]
	NONE = 0,
	## Used for gathering Stardust Fertilizer [br]
	## shortcut key: [lb][code]Q[/code][rb]
	PICKAXE = 1,
	## Used for watering plants [br]
	## shortcut key: [lb][code]E[/code][rb]
	WATERING_CAN = 2,
	## Used for fertilizing plants [br]
	## shortcut key: [lb][code]F[/code][rb]
	FERTILIZER = 3,
	## Used for planting seeds(Last seed used, defaults to Pulsar Puff) [br]
	## shortcut key: [lb][code]R[/code][rb]
	SEEDS = 4,
	## Used for planting Pulsar Puff [br]
	## shortcut key: [lb][code]1[/code][rb]
	PULSAR_PUFF_SEEDS = 5 + 10,
	## Used for planting Rocarrot [br]
	## shortcut key: [lb][code]2[/code][rb]
	ROCARROT_SEEDS = 6 + 10,
	## Used for planting Saturose [br]
	## shortcut key: [lb][code]3[/code][rb]
	SATUROSE_SEEDS = 7 + 10,
	## Used for planting White Dwarf Dropflower [br]
	## shortcut key: [lb][code]4[/code][rb]
	WHITE_DWARF_DROPFLOWER_SEEDS = 8 + 10,
	## Used for planting Moon Orchid [br]
	## shortcut key: [lb][code]5[/code][rb]
	MOON_ORCHID_SEEDS = 9 + 10,
	## Used for planting Nursery Melon [br]
	## shortcut key: [lb][code]6[/code][rb]
	NURSERY_MELON_SEEDS = 10 + 10,
	## Used for planting Stellar Cabbage [br]
	## shortcut key: [lb][code]7[/code][rb]
	STELLAR_CABBAGE_SEEDS = 11 + 10,
	## Used for planting Moonberry Bush [br]
	## shortcut key: [lb][code]8[/code][rb]
	MOONBERRY_BUSH_SEEDS = 12 + 10,
	## Used for planting Star Cluster [br]
	## shortcut key: [lb][code]9[/code][rb]
	STAR_CLUSTER_SEEDS = 13 + 10,
	## Used for planting Basket Stinkhorn [br]
	## shortcut key: [lb][code]0[/code][rb]
	BASKET_STINKHORN_SEEDS = 14 + 10,
	## Used for planting Gas Giant Gourd [br]
	## shortcut key: [lb][code]-[/code][rb]
	GAS_GIANT_GOURD_SEEDS = 15 + 10,
	## Used for planting Heart of the Stars [br]
	## shortcut key: [lb][code]=[/code][rb]
	HEART_OF_THE_STARS_SEEDS = 16 + 10,
}

const TOOL_TYPE_NAMES = {
	Type.NONE: "None",
	Type.PICKAXE: "Pickaxe",
	Type.WATERING_CAN: "Watering Can",
	Type.FERTILIZER: "Fertilizer",
	Type.SEEDS: "Seeds",
	Type.PULSAR_PUFF_SEEDS: "Pulsar Puff Seeds",
	Type.ROCARROT_SEEDS: "Rocarrot Seeds",
	Type.SATUROSE_SEEDS: "Saturose Seeds",
	Type.WHITE_DWARF_DROPFLOWER_SEEDS: "White Dwarf Dropflower Seeds",
	Type.MOON_ORCHID_SEEDS: "Moon Orchid Seeds",
	Type.NURSERY_MELON_SEEDS: "Nursery Melon Seeds",
	Type.STELLAR_CABBAGE_SEEDS: "Stellar Cabbage Seeds",
	Type.MOONBERRY_BUSH_SEEDS: "Moonberry Bush Seeds",
	Type.STAR_CLUSTER_SEEDS: "Star Cluster Seeds",
	Type.BASKET_STINKHORN_SEEDS: "Basket Stinkhorn Seeds",
	Type.GAS_GIANT_GOURD_SEEDS: "Gas Giant Gourd Seeds",
	Type.HEART_OF_THE_STARS_SEEDS: "Heart of the Stars Seeds",
}

static var current_unlock_level: int:
	get:
		return _current_unlock_level
	set(_value):
		pass

static var _current_unlock_level: int = 99

@export_placeholder("None") var name: String
@export var type: Type = Type.NONE
@export var icon: Texture2D = null

@export var countable: bool = false
@export var max_quantity: int = 0


static func increment_unlock_level() -> void:
	_current_unlock_level += 1


static func none() -> Tool:
	var tool = Tool.new()
	tool.type = Type.NONE
	return tool


func plant() -> PlantDetails.PlantType:
	if type >= PlantDetails.PlantType.PULSAR_PUFF:
		return type as PlantDetails.PlantType
	print_rich("Tool [color=yellow]" + name + "[/color] cannot be planted.")
	return PlantDetails.PlantType.NONE


static func tool_type_to_string(_type: Type) -> String:
	return TOOL_TYPE_NAMES.get(_type, "Unknown")
