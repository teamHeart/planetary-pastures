class_name Upgrade
extends Resource

@export_category("Basic Info")

##Upgrade Icon
@export var icon : Texture2D

## Upgrade name
@export_placeholder("String") var name : String


## A description of what this upgrade does
@export_multiline("description") var description : String

@export_category("Unlocking Info")

## The parent upgrade that leads into this one[br]
## [color=#808080][i](leave empty it this upgrade is the root of the upgrade tree)[/i][/color]
@export var parent_upgrade : Upgrade

## The level of the parent upgrade required to make this upgrade available[br]
## [color=#808080][i](no effect if this upgrade is the root upgrade)[/i][/color]
@export_range(1, PROPERTY_HINT_MAX, 1) var unlock_level : int

## Information pertaining to leveling up the upgrade
@export_category("Leveling Info")

## The maximum level of the upgrade[br]
## [color=#808080][i](enter 0 if no max level)[/i][/color]
@export_range(0, PROPERTY_HINT_MAX, 1) var max_level : int

## The cost to level up the upgrade[br]
@export_range(1, PROPERTY_HINT_MAX, 1) var upgrade_cost : int

## The growth rate of the upgrade cost per level[br]
@export_exp_easing("positive_only") var cost_growth = 1.5

@export_category("Parameter Info")

## The starting value of the parameter that the upgrade affects[br]
## [color=#808080][i](this is the value of the parameter at level 0 of the upgrade)[/i][/color]
@export var base_value : Variant

## The amount that the upgrade increases the parameter per level[br]
## [color=#808080][i](can be negative for upgrades that decrease a parameter)[/i][/color]
@export_range(-1.0, 1.0, 0.01) var parameter_increase : float = 1.0

## Whether the upgrade's effects are percentage or additive[br]
## [color=#808080][i](percentage upgrades increase the parameter by[/i][/color][br]
## [param base_value]*(1+([param parameter_increase]*[param upgrade_level]))[br]
## [color=#808080][i]per level, while additive upgrades add parameter_increase per level)[/i]
## [/color][br][br]
## [code]Addative = 0,    Percentage = 1[/code]
@export_enum("Additive", "Percentage") var is_percentage : int