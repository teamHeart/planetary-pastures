class_name PlantDetails
extends Resource

enum PlantType {
	NONE = 0,
	PULSAR_PUFF = 5 + 10,
	ROCARROT = 6 + 10,
	SATUROSE = 7 + 10,
	WHITE_DWARF_DROPFLOWER = 8 + 10,
	MOON_ORCHID = 9 + 10,
	NURSERY_MELON = 10 + 10,
	STELLAR_CABBAGE = 11 + 10,
	MOONBERRY_BUSH = 12 + 10,
	STAR_CLUSTER = 13 + 10,
	BASKET_STINKHORN = 14 + 10,
	GAS_GIANT_GOURD = 15 + 10,
	HEART_OF_THE_STARS = 16 + 10,
}

const PLANT_TYPE_NAMES = {
	PlantType.NONE: "None",
	PlantType.PULSAR_PUFF: "Pulsar Puff",
	PlantType.ROCARROT: "Rocarrot",
	PlantType.SATUROSE: "Saturose",
	PlantType.WHITE_DWARF_DROPFLOWER: "White Dwarf Dropflower",
	PlantType.MOON_ORCHID: "Moon Orchid",
	PlantType.NURSERY_MELON: "Nursery Melon",
	PlantType.STELLAR_CABBAGE: "Stellar Cabbage",
	PlantType.MOONBERRY_BUSH: "Moonberry Bush",
	PlantType.STAR_CLUSTER: "Star Cluster",
	PlantType.BASKET_STINKHORN: "Basket Stinkhorn",
	PlantType.GAS_GIANT_GOURD: "Gas Giant Gourd",
	PlantType.HEART_OF_THE_STARS: "Heart of the Stars",
}
## The type of plant. [code]PlantDetails.PlantType[/code]
@export var plant_type: PlantType = PlantType.NONE
## The name of the plant. [code]String[/code]
@export var plant_name: String = ""
## A description of the plant. [code]String[/code]
@export_multiline var description: String = ""

## The time it takes to plant the seed [code]float[/code]
@export var plant_time: float = 0.0
## The time it takes to sprout after planting [code]float[/code]
@export var gestation_time: float = 0.0
## The time it takes to grow after sprouting [code]float[/code]
@export var growth_time: float = 0.0
## the time it takes to harvest after fully grown [code]float[/code]
@export var harvest_time: float = 0.0

## the amount of plant yield after harvesting [code]int[/code]
@export var yield_amount: int = 0

@export var growth_texture: CompressedTexture2D = null
@export var grown_animation: SpriteFrames = null


static func plant_type_to_string(_plant_type: PlantType) -> String:
	return PLANT_TYPE_NAMES.get(_plant_type, "Unknown")
