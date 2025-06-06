extends Node

var current_plant_name: String = "Potato"

var plant_data_by_name := {
	"carrot": preload("res://Scenes & Scripts/Globals/PlantData/Carrot.tres"),
	"potato": preload("res://Scenes & Scripts/Globals/PlantData/Potato.tres"),
	"radish": preload("res://Scenes & Scripts/Globals/PlantData/Radish.tres"),
	"onion": preload("res://Scenes & Scripts/Globals/PlantData/Onion.tres"),
	"beetroot": preload("res://Scenes & Scripts/Globals/PlantData/Beetroot.tres"),
	"lettuce": preload("res://Scenes & Scripts/Globals/PlantData/Lettuce.tres"),
	"pumpkin": preload("res://Scenes & Scripts/Globals/PlantData/Pumpkin.tres"),
	
}

func get_current_plant_data() -> PlantData:
	if plant_data_by_name.has(current_plant_name):
		return plant_data_by_name[current_plant_name]
	return null
