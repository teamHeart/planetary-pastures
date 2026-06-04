class_name UpgradeCard
extends Control

@export var upgrade : Upgrade

@onready var upgrade_name : Label = %Name
@onready var upgrade_icon : TextureRect = %Icon
@onready var upgrade_description : Label = %Description
@onready var upgrade_cost : Label = %Cost
@onready var upgrade_progress : ProgressBar = %ProgressBar
@onready var upgrade_level : Label = %Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(upgrade):
		upgrade_icon.texture = upgrade.icon
