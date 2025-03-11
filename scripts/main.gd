extends Node2D

@export var bird: Bird
@export var background: TileMapLayer

@export var grass_animation: AnimationPlayer
@export var cloud_animation: AnimationPlayer
@export var building_animation: AnimationPlayer

func _ready():
	bird.on_death.connect(_game_over)

func _game_over():
	print("Game over")
	grass_animation.pause()
	cloud_animation.pause()
	building_animation.pause()
