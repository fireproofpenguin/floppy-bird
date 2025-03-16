@tool
class_name Pipe extends AnimatableBody2D

@export var pipe_top: Sprite2D
@export var pipe_body: Node2D
@export var pipe_sprite: Texture
@export var collision_shape: CollisionShape2D
@export var flipped: bool

@export var height: int = 1:
	set(value):
		height = value
		if Engine.is_editor_hint():
			_set_size()

func _ready() -> void:
	_set_size()

func _set_size() -> void:
	for child in pipe_body.get_children():
		pipe_body.remove_child(child)
		
	for n in range(height):
		var body_segment: Sprite2D = Sprite2D.new()
		body_segment.texture = pipe_sprite
		var y = (n * 16) + 8
		if not flipped:
			y = -y
		body_segment.position = Vector2(0, y)
		body_segment.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		pipe_body.add_child(body_segment)
		
	var pipe_top_y = (height * 16) + 2
	if not flipped:
		pipe_top_y = -pipe_top_y - 6
		
	pipe_top.position = Vector2(0, pipe_top_y)
	
	var collision_shape_height = (height * 16) + 10
	var collision_shape_rect: RectangleShape2D = RectangleShape2D.new()
	collision_shape_rect.size = Vector2(22, collision_shape_height)
	collision_shape.shape = collision_shape_rect
	if flipped:
		collision_shape.position.y = collision_shape_height / 2
	else:
		collision_shape.position.y = -collision_shape_height / 2
