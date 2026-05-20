class_name Upgrade
extends Resource

@export_category("Basic Info")

##Upgrade Icon
@export var icon : Texture2D

## Upgrade name
@export_placeholder("String") var name : String

## The maximum level of the upgrade[br]
## [color=#808080][i](enter 0 if no max level)[/i][/color]
@export_range(0, PROPERTY_HINT_MAX, 1) var max_level : int

## A description of what this upgrade does
@export_multiline("description") var description : String

@export_category("Unlocking Info")

## The parent upgrade that leads into this one[br]
## [color=#808080][i](leave empty it this upgrade is the root of the upgrade tree)[/i][/color]
@export var parentUpgrade : Upgrade

## The level of the parent upgrade required to make this upgrade available[br]
## [color=#808080][i](no effect if this upgrade is the root upgrade)[/i][/color]
@export_range(1, PROPERTY_HINT_MAX, 1) var unlockLevel : int
