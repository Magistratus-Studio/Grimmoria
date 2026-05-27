extends Control

@onready var main: PackedScene = load("res://Cenas/menu_inicial.tscn")

func _on_button_iniciar_pressed() -> void:
	get_tree().change_scene_to_packed(main)
