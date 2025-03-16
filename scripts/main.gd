extends Node2D

@export var bird: Bird
@export var background: TileMapLayer

@export var grass_animation: AnimationPlayer
@export var cloud_animation: AnimationPlayer
@export var building_animation: AnimationPlayer

@export var game_over_scene: PackedScene
@export var hud: CanvasLayer

@export var pipe_scene: PackedScene
@export var pipe_timer: Timer

@export var audio_player: AudioStreamPlayer
@export var score_hud: Score
@export var pipes: Node2D

var score = 0

var top = 0
var bottom = 272

var pipe_speed = 2.0

var is_game_over = false
var min_height = 2
var max_height = 6
var is_ceiling_enabled = false
var spawn_count = 0
var double_chance = 0
var min_gap = 5

func _ready():
	bird.on_death.connect(_game_over)
	
func _physics_process(delta):
	if not is_game_over:
		for pipe in pipes.get_children():
			if pipe.position.x < -11:
				pipe.queue_free()

			pipe.position = pipe.position.lerp(Vector2(pipe.position.x - 1, pipe.position.y), pipe_speed)
			if pipe.position.x == 100:
				_increase_score()

func _game_over():
	print("Game over")
	is_game_over = true
	pipe_timer.stop()
	grass_animation.pause()
	cloud_animation.pause()
	building_animation.pause()

	var game_over: GameOver = game_over_scene.instantiate();
	game_over.restart_game.connect(_restart)
	
	hud.add_child(game_over)

func _restart():
	get_tree().reload_current_scene()

func _on_pipe_timer_timeout():
	_spawn_pipe()

func _spawn_pipe():
	# Spawns a pipe
	var is_double = randi() % double_chance == 0 if double_chance > 0 else false
	
	if is_double:
		var top_pipe: Pipe = pipe_scene.instantiate()
		var bottom_pipe: Pipe = pipe_scene.instantiate()
		var top_height = randi_range(min_height - 1, max_height - 1)
		var bottom_height = min(randi_range(min_height, (max_height + top_height) - min_gap), 1)
		top_pipe.flipped = true
		top_pipe.height = top_height
		top_pipe.position = Vector2(640, top)
		bottom_pipe.flipped = false
		bottom_pipe.height = bottom_height
		bottom_pipe.position = Vector2(640, bottom)
		pipes.add_child(top_pipe)
		pipes.add_child(bottom_pipe)
	else:
		var pipe: Pipe = pipe_scene.instantiate()
		
		var is_top = randi() % 2 == 0 if is_ceiling_enabled else false
		var y_coord = top if is_top else bottom
		pipe.flipped = is_top
		var pipe_height = randi_range(min_height, max_height)
		pipe.height = pipe_height
		pipe.position = Vector2(640, y_coord)
		pipes.add_child(pipe)
	
	spawn_count += 1
	_change_difficulty()

func _increase_score():
	score += 1
	score_hud.set_score(score)
	audio_player.play()
	
func _change_difficulty():
	match spawn_count:
		5:
			is_ceiling_enabled = true
		7:
			pipe_timer.wait_time = 2
			double_chance = 3	
		10:
			min_gap = 6
		12:
			min_height *= 2
			max_height *= 2
		14:
			min_gap = 3
		20:
			pipe_timer.wait_time = 1
