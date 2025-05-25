extends Node

var current_plant_name: String = "Potato"

var plant_data_by_name := {
	"Carrot": preload("res://Scenes & Scripts/Globals/PlantData/Carrot.tres"),
	"Potato": preload("res://Scenes & Scripts/Globals/PlantData/Potato.tres"),
	"Radish": preload("res://Scenes & Scripts/Globals/PlantData/Radish.tres"),
	"Onion": preload("res://Scenes & Scripts/Globals/PlantData/Onion.tres"),
	"Beetroot": preload("res://Scenes & Scripts/Globals/PlantData/Beetroot.tres"),
	"Lettuce": preload("res://Scenes & Scripts/Globals/PlantData/Lettuce.tres"),
}

func get_current_plant_data() -> PlantData:
	if plant_data_by_name.has(current_plant_name):
		return plant_data_by_name[current_plant_name]
	return null
