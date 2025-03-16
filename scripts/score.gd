class_name Score extends HBoxContainer

@export var score_label: Label

func set_score(score: int):
	score_label.text = str(score)
