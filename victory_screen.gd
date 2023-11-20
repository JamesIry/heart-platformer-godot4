extends CanvasLayer

@onready var main_menu_button = %MainMenuButton

func _ready():
	main_menu_button.grab_focus()
	LevelTransition.fade_from_black()	

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")
