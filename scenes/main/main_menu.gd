extends Control

## Main Menu
## Simple menu principal con placeholders


func _ready() -> void:
	print("Main Menu loaded")


func _on_btn_new_game_pressed() -> void:
	print("New Game clicked")
	# TODO: Ir a selección de nivel o nivel 1 directamente
	# Por ahora vamos a la escena de prueba V2 (Player completo)
	SceneManager.load_scene("res://scenes/main/test_scene_v2.tscn")


func _on_btn_test_scene_pressed() -> void:
	print("Test Scene clicked")
	SceneManager.load_scene("res://scenes/main/test_scene_v2.tscn")


func _on_btn_quit_pressed() -> void:
	print("Quit clicked")
	get_tree().quit()
