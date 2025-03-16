class_name GameOver extends CenterContainer

@export var restart_button: Button

signal restart_game

func _enter_tree():
	restart_button.grab_focus()

func _on_button_pressed():
	restart_game.emit()
