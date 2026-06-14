class_name PlantDetails
extends Resource

enum PlantType {
	NONE, BASKET_STINKHORN, GAS_GIANT_GOURD, HEART_OF_THE_STARS, MOON_ORCHID, MOONBERRY_BUSH
}

@export var plant_type: PlantType = PlantType.NONE
@export var plant_name: String = ""
@export_multiline var description: String = ""

@export var gestation_time: float = 0.0
@export var growth_time: float = 0.0

@export var yield_amount: int = 0

@export var plant_time: float = 0.0
@export var harvest_time: float = 0.0

@export var growth_texture: CompressedTexture2D = null
@export var grown_animation: SpriteFrames = null


static func plant_type_to_string(_plant_type: PlantType) -> String:
	match _plant_type:
		PlantType.NONE:
			return "None"
		PlantType.BASKET_STINKHORN:
			return "Basket Stinkhorn"
		PlantType.GAS_GIANT_GOURD:
			return "Gas Giant Gourd"
		PlantType.HEART_OF_THE_STARS:
			return "Heart of the Stars"
		PlantType.MOON_ORCHID:
			return "Moon Orchid"
		PlantType.MOONBERRY_BUSH:
			return "Moonberry Bush"
		_:
			return "Unknown"
